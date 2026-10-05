import 'dart:async' show unawaited;

import 'package:mahafez_core/mahafez_core.dart';
import 'package:sms_engine/sms_engine.dart';

import '../../../wallets/domain/entities/wallet_entity.dart';
import '../../../wallets/domain/repositories/wallet_repository.dart';
import '../../domain/entities/missing_transactions_preview.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/entities/transaction_date_range.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_history_entry_entity.dart';
import '../../domain/entities/transaction_page.dart';
import '../../domain/entities/transaction_paid_status_filter.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/entities/transactions_overview_entity.dart';
import '../datasources/deleted_transaction_local_data_source.dart';
import '../datasources/multi_wallet_transaction_remote_data_source.dart';
import '../datasources/multi_wallet_transactions_overview_remote_data_source.dart';
import '../datasources/transaction_cache_local_data_source.dart';
import '../datasources/transaction_watch_remote_data_source.dart';
import '../datasources/wallet_transaction_remote_data_source.dart';
import '../models/transaction_dto.dart';

final class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl({
    required TransactionWatchRemoteDataSource transactionWatchRemoteDataSource,
    required WalletTransactionRemoteDataSource walletRemoteDataSource,
    required TransactionCacheLocalDataSource cacheDataSource,
    required DeletedTransactionLocalDataSource deletedTransactionLocalDataSource,
    required WalletRepository walletRepository,
    required InboxSmsService inboxSmsService,
    required MultiWalletTransactionRemoteDataSource multiWalletRemoteDataSource,
    required MultiWalletTransactionsOverviewRemoteDataSource multiWalletOverviewRemoteDataSource,
  })  : _transactionWatchRemoteDataSource = transactionWatchRemoteDataSource,
        _walletRemoteDataSource = walletRemoteDataSource,
        _cacheDataSource = cacheDataSource,
        _deletedTransactionLocalDataSource = deletedTransactionLocalDataSource,
        _walletRepository = walletRepository,
        _inboxSmsService = inboxSmsService,
        _multiWalletRemoteDataSource = multiWalletRemoteDataSource,
        _multiWalletOverviewRemoteDataSource = multiWalletOverviewRemoteDataSource;

  final TransactionWatchRemoteDataSource _transactionWatchRemoteDataSource;
  final WalletTransactionRemoteDataSource _walletRemoteDataSource;
  final TransactionCacheLocalDataSource _cacheDataSource;
  final DeletedTransactionLocalDataSource _deletedTransactionLocalDataSource;
  final WalletRepository _walletRepository;
  final InboxSmsService _inboxSmsService;
  final MultiWalletTransactionRemoteDataSource _multiWalletRemoteDataSource;
  final MultiWalletTransactionsOverviewRemoteDataSource _multiWalletOverviewRemoteDataSource;

  Future<Result<T>> _execute<T>(Future<T> Function() action) async {
    try {
      final value = await action();
      return Success(value);
    } on Failure catch (failure) {
      return FailureResult(failure);
    } catch (e) {
      return FailureResult(UnknownFailure(technicalMessage: e.toString()));
    }
  }

  // ── Queries ──────────────────────────────────────────────────────────────

  @override
  Future<Result<TransactionPage>> getTransactions({
    required List<String> walletIds,
    TransactionType? type,
    TransactionPaidStatusFilter paidStatusFilter =
        TransactionPaidStatusFilter.all,
    String? counterpartySuffixQuery,
    TransactionDateRange? dateRange,
    int limit = 20,
    TransactionsPageCursor? cursor,
  }) {
    return _execute(() async {
      final page = await _multiWalletRemoteDataSource.getTransactions(
        walletIds: walletIds,
        type: type,
        paidStatusFilter: paidStatusFilter,
        counterpartySuffixQuery: counterpartySuffixQuery,
        dateRange: dateRange,
        limit: limit,
        cursor: cursor,
      );
      return page.toEntity();
    });
  }

  @override
  Future<Result<TransactionsOverviewEntity>> getTransactionsOverview({
    required List<String> walletIds,
  }) {
    return _execute(() async {
      final overview =
          await _multiWalletOverviewRemoteDataSource.getTransactionsOverview(
        walletIds: walletIds,
      );
      return overview.toEntity();
    });
  }

  @override
  Future<Result<TransactionPage>> getWalletTransactions({
    required String walletId,
    TransactionType? type,
    TransactionPaidStatusFilter paidStatusFilter =
        TransactionPaidStatusFilter.all,
    String? counterpartySuffixQuery,
    TransactionDateRange? dateRange,
    int limit = 20,
    WalletTransactionsPageCursor? cursor,
  }) {
    return _execute(() async {
      final isDefaultFirstPage =
          cursor == null &&
          type == null &&
          paidStatusFilter == TransactionPaidStatusFilter.all &&
          (counterpartySuffixQuery == null || counterpartySuffixQuery.isEmpty) &&
          dateRange == null;

      final page = await _walletRemoteDataSource.getWalletTransactions(
        walletId: walletId,
        type: type,
        paidStatusFilter: paidStatusFilter,
        counterpartySuffixQuery: counterpartySuffixQuery,
        dateRange: dateRange,
        limit: limit,
        cursor: cursor,
      );

      if (isDefaultFirstPage) {
        unawaited(
          _cacheDataSource.saveFirstPage(
            walletId,
            page,
          ),
        );
      }

      return page.toEntity();
    });
  }

  @override
  Stream<Result<TransactionEntity>> watchTransaction({
    required String walletId,
    required String transactionId,
  }) {
    return _transactionWatchRemoteDataSource
        .watchTransaction(walletId: walletId, transactionId: transactionId)
        .map((dto) => Success<TransactionEntity>(dto.toEntity()))
        .handleError((Object error) {
      if (error is Failure) {
        return FailureResult<TransactionEntity>(error);
      }
      return FailureResult<TransactionEntity>(
        UnknownFailure(technicalMessage: error.toString()),
      );
    });
  }

  @override
  Future<Result<DateTime?>> getLatestTransactionDate(String walletId) {
    return _execute(() async {
      final transactions = await _walletRemoteDataSource.getWalletTransactions(
        walletId: walletId,
        limit: 1,
      );
      if (transactions.transactions.isEmpty) return null;
      return transactions.transactions.first.createdAt;
    });
  }

  @override
  Future<Result<MissingTransactionsPreview>> previewMissingTransactions(
    String walletId,
  ) {
    return _execute(() async {
      final walletsResult = await _walletRepository.getWallets();
      final allWallets = switch (walletsResult) {
        Success(:final data) => data,
        FailureResult(:final failure) => throw failure,
      };

      final targetWallet = allWallets.cast<WalletEntity?>().firstWhere(
            (w) => w?.id == walletId,
            orElse: () => null,
          );

      if (targetWallet == null) {
        return const MissingTransactionsPreview(
          transactions: [],
        );
      }

      final latestDate = await _walletRemoteDataSource
          .getWalletTransactions(walletId: walletId, limit: 1)
          .then((p) => p.transactions.isEmpty ? null : p.transactions.first.createdAt);

      final sameProviderWallets = allWallets
          .where((w) => w.provider == targetWallet.provider && w.id != targetWallet.id)
          .map((w) => w.phoneNumber)
          .toList();

      final records = await _inboxSmsService.getMatchedHistoricalRecords(
        provider: targetWallet.provider,
        phoneNumber: targetWallet.phoneNumber,
        sameProviderWalletPhoneNumbers: sameProviderWallets,
        sinceDate: latestDate,
      );

      final existingRemote = await _walletRemoteDataSource.getTransactionsSince(
        walletId: walletId,
        fromDate: latestDate ?? DateTime(2000),
      );
      final existingHashes = existingRemote.map((e) => e.message ?? '').toSet();

      final missing = <TransactionEntity>[];
      for (final record in records) {
        if (existingHashes.contains(record.body)) continue;

        missing.add(
          TransactionEntity(
            id: '${targetWallet.id}_${record.createdAt.millisecondsSinceEpoch}_${record.body.hashCode.toRadixString(16)}',
            type: record.parseResult.type,
            amount: record.parseResult.amount,
            createdAt: record.createdAt,
            walletId: targetWallet.id,
            walletOwnerUid: targetWallet.ownerUid,
            provider: targetWallet.provider,
            phoneNumber: targetWallet.phoneNumber,
            counterpartyNumber: record.parseResult.counterpartyNumber,
            referenceNumber: record.parseResult.referenceNumber,
            message: record.body,
            statusBalance: record.parseResult.balance,
          ),
        );
      }

      return MissingTransactionsPreview(
        transactions: missing,
        fromDate: latestDate,
      );
    });
  }

  // ── Mutations ────────────────────────────────────────────────────────────

  @override
  Future<Result<void>> markAsPaid({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
  }) {
    return _execute(() => _walletRemoteDataSource.markAsPaid(
          walletId: walletId,
          transactionId: transactionId,
          userId: userId,
          userName: userName,
        ));
  }

  @override
  Future<Result<void>> markAsUnpaid({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
  }) {
    return _execute(() => _walletRemoteDataSource.markAsUnpaid(
          walletId: walletId,
          transactionId: transactionId,
          userId: userId,
          userName: userName,
        ));
  }

  @override
  Future<Result<void>> addNote({
    required String walletId,
    required String transactionId,
    required String text,
    required String userId,
    required String userName,
  }) {
    return _execute(() => _walletRemoteDataSource.addNote(
          walletId: walletId,
          transactionId: transactionId,
          text: text,
          userId: userId,
          userName: userName,
        ));
  }

  @override
  Future<Result<void>> editNote({
    required String walletId,
    required String transactionId,
    required String noteId,
    required String text,
  }) {
    return _execute(() => _walletRemoteDataSource.editNote(
          walletId: walletId,
          transactionId: transactionId,
          noteId: noteId,
          text: text,
        ));
  }

  @override
  Future<Result<void>> deleteNote({
    required String walletId,
    required String transactionId,
    required String noteId,
  }) {
    return _execute(() => _walletRemoteDataSource.deleteNote(
          walletId: walletId,
          transactionId: transactionId,
          noteId: noteId,
        ));
  }

  @override
  Future<Result<void>> saveTransaction(
    TransactionEntity transaction, {
    bool allowLocallyDeletedRestore = false,
  }) {
    return _execute(() async {
      await _walletRemoteDataSource.saveTransaction(
        TransactionDto.fromEntity(transaction),
      );
      unawaited(_cacheDataSource.clear(transaction.walletId));
    });
  }

  @override
  Future<Result<void>> deleteTransaction({
    required String walletId,
    required String transactionId,
    required String userId,
  }) {
    return _execute(() async {
      await _walletRemoteDataSource.deleteTransaction(
        walletId: walletId,
        transactionId: transactionId,
        userId: userId,
      );
      await _deletedTransactionLocalDataSource.markDeleted(transactionId);
    });
  }

  @override
  Stream<Result<List<NoteEntity>>> getNotes({
    required String walletId,
    required String transactionId,
  }) {
    return _walletRemoteDataSource
        .getNotes(walletId: walletId, transactionId: transactionId)
        .map((dtos) => Success<List<NoteEntity>>(
              dtos.map((dto) => dto.toEntity()).toList(),
            ))
        .handleError((Object error) {
      if (error is Failure) {
        return FailureResult<List<NoteEntity>>(error);
      }
      return FailureResult<List<NoteEntity>>(
        UnknownFailure(technicalMessage: error.toString()),
      );
    });
  }

  @override
  Stream<Result<List<TransactionHistoryEntryEntity>>> getTransactionHistory({
    required String walletId,
    required String transactionId,
  }) {
    return _walletRemoteDataSource
        .getTransactionHistory(walletId: walletId, transactionId: transactionId)
        .map((dtos) => Success<List<TransactionHistoryEntryEntity>>(
              dtos.map((dto) => dto.toEntity()).toList(),
            ))
        .handleError((Object error) {
      if (error is Failure) {
        return FailureResult<List<TransactionHistoryEntryEntity>>(error);
      }
      return FailureResult<List<TransactionHistoryEntryEntity>>(
        UnknownFailure(technicalMessage: error.toString()),
      );
    });
  }
}
