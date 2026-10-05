import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahafez_core/mahafez_core.dart';

import '../../domain/entities/transaction_date_range.dart';
import '../../domain/entities/transaction_page.dart';
import '../../domain/entities/transaction_paid_status_filter.dart';
import '../models/transaction_dto.dart';
import '../models/transaction_page_dto.dart';
import 'transaction_firestore_support.dart';

abstract interface class MultiWalletTransactionRemoteDataSource {
  Future<TransactionPageDto> getTransactions({
    required List<String> walletIds,
    TransactionType? type,
    TransactionPaidStatusFilter paidStatusFilter =
        TransactionPaidStatusFilter.all,
    String? counterpartySuffixQuery,
    TransactionDateRange? dateRange,
    int limit = 20,
    TransactionsPageCursor? cursor,
  });
}

final class MultiWalletTransactionRemoteDataSourceImpl
    implements MultiWalletTransactionRemoteDataSource {
  const MultiWalletTransactionRemoteDataSourceImpl({
    required this._support,
  });

  final TransactionFirestoreSupport _support;

  @override
  Future<TransactionPageDto> getTransactions({
    required List<String> walletIds,
    TransactionType? type,
    TransactionPaidStatusFilter paidStatusFilter =
        TransactionPaidStatusFilter.all,
    String? counterpartySuffixQuery,
    TransactionDateRange? dateRange,
    int limit = 20,
    TransactionsPageCursor? cursor,
  }) async {
    if (walletIds.isEmpty || limit <= 0) {
      return const TransactionPageDto(
        transactions: <TransactionDto>[],
        totalCount: 0,
      );
    }

    final totalCount = await _countTransactions(
      walletIds: walletIds,
      type: type,
      paidStatusFilter: paidStatusFilter,
      counterpartySuffixQuery: counterpartySuffixQuery,
      dateRange: dateRange,
    );

    final resumeCursors = switch (cursor) {
      MultiWalletTransactionsPageCursor(:final walletCursors) => walletCursors,
      _ => null,
    };

    final states = await Future.wait(
      walletIds.map(
        (walletId) => _createWalletTransactionState(
          walletId: walletId,
          resumeCursor: resumeCursors?[walletId],
        ),
      ),
    );

    final transactions = await _collectLatestTransactions(
      states: states,
      type: type,
      paidStatusFilter: paidStatusFilter,
      counterpartySuffixQuery: counterpartySuffixQuery,
      dateRange: dateRange,
      limit: limit,
    );

    final nextCandidate = await _selectLatestTransaction(
      states: states,
      batchSize: _resolveBatchSize(limit),
      type: type,
      paidStatusFilter: paidStatusFilter,
      counterpartySuffixQuery: counterpartySuffixQuery,
      dateRange: dateRange,
    );

    final nextCursor = nextCandidate == null
        ? null
        : MultiWalletTransactionsPageCursor(
            walletCursors: {
              for (final state in states)
                if (state.consumedCursor != null)
                  state.walletId: state.consumedCursor!
                else if (state.resumeCursor != null)
                  state.walletId: state.resumeCursor!,
            },
          );

    return TransactionPageDto(
      transactions: transactions,
      totalCount: totalCount,
      nextCursor: nextCursor,
    );
  }

  Future<_WalletTransactionState> _createWalletTransactionState({
    required String walletId,
    WalletTransactionsPageCursor? resumeCursor,
  }) async {
    final meta = await _support.walletMeta(walletId);
    return _WalletTransactionState(
      walletId: walletId,
      provider: meta.provider,
      phoneNumber: meta.phoneNumber,
      ownerUid: meta.ownerUid,
      resumeCursor: resumeCursor,
    );
  }

  Future<List<TransactionDto>> _collectLatestTransactions({
    required List<_WalletTransactionState> states,
    required int limit,
    required TransactionType? type,
    required TransactionPaidStatusFilter paidStatusFilter,
    required String? counterpartySuffixQuery,
    required TransactionDateRange? dateRange,
  }) async {
    final results = <TransactionDto>[];
    final batchSize = _resolveBatchSize(limit);

    while (results.length < limit) {
      final candidate = await _selectLatestTransaction(
        states: states,
        batchSize: batchSize,
        type: type,
        paidStatusFilter: paidStatusFilter,
        counterpartySuffixQuery: counterpartySuffixQuery,
        dateRange: dateRange,
      );
      if (candidate == null) {
        break;
      }

      results.add(candidate.transaction);
      candidate.state.pendingTransactions.removeAt(0);
      candidate.state.consumedCursor = WalletTransactionsPageCursor(
        createdAt: candidate.transaction.createdAt,
        transactionId: candidate.transaction.id,
      );
    }

    return results;
  }

  Future<_WalletTransactionCandidate?> _selectLatestTransaction({
    required List<_WalletTransactionState> states,
    required int batchSize,
    required TransactionType? type,
    required TransactionPaidStatusFilter paidStatusFilter,
    required String? counterpartySuffixQuery,
    required TransactionDateRange? dateRange,
  }) async {
    _WalletTransactionCandidate? selectedCandidate;

    for (final state in states) {
      final transaction = await _peekTransaction(
        state: state,
        batchSize: batchSize,
        type: type,
        paidStatusFilter: paidStatusFilter,
        counterpartySuffixQuery: counterpartySuffixQuery,
        dateRange: dateRange,
      );
      if (transaction == null) {
        continue;
      }

      if (selectedCandidate == null ||
          _isTransactionAfter(transaction, selectedCandidate.transaction)) {
        selectedCandidate = _WalletTransactionCandidate(
          state: state,
          transaction: transaction,
        );
      }
    }

    return selectedCandidate;
  }

  Future<TransactionDto?> _peekTransaction({
    required _WalletTransactionState state,
    required int batchSize,
    required TransactionType? type,
    required TransactionPaidStatusFilter paidStatusFilter,
    required String? counterpartySuffixQuery,
    required TransactionDateRange? dateRange,
  }) async {
    if (state.pendingTransactions.isNotEmpty) {
      return state.pendingTransactions.first;
    }
    if (state.exhausted) {
      return null;
    }

    final batch = await _fetchTransactionBatch(
      state: state,
      batchSize: batchSize,
      type: type,
      paidStatusFilter: paidStatusFilter,
      counterpartySuffixQuery: counterpartySuffixQuery,
      dateRange: dateRange,
    );

    state.pendingTransactions.addAll(batch.transactions);
    state.lastFetchedDocument = batch.lastFetchedDocument;
    state.exhausted = batch.transactions.length < batchSize;

    if (state.pendingTransactions.isEmpty) {
      return null;
    }

    return state.pendingTransactions.first;
  }

  Future<_TransactionBatch> _fetchTransactionBatch({
    required _WalletTransactionState state,
    required int batchSize,
    required TransactionType? type,
    required TransactionPaidStatusFilter paidStatusFilter,
    required String? counterpartySuffixQuery,
    required TransactionDateRange? dateRange,
  }) async {
    var query = _support.applyFilters(
      _support.walletTransactionsQuery(state.walletId),
      type: type,
      paidStatusFilter: paidStatusFilter,
      counterpartySuffixQuery: counterpartySuffixQuery,
      dateRange: dateRange,
    );
    if (state.lastFetchedDocument != null) {
      query = query.startAfterDocument(state.lastFetchedDocument!);
    } else if (state.resumeCursor != null) {
      query = query.startAfter([
        Timestamp.fromDate(state.resumeCursor!.createdAt),
        state.resumeCursor!.transactionId,
      ]);
    }

    final snapshot = await query.limit(batchSize).get();
    final transactions = snapshot.docs
        .map(
          (doc) => TransactionDto.fromFirestore(
            doc,
            state.provider,
            state.phoneNumber,
            state.walletId,
            state.ownerUid,
          ),
        )
        .toList();

    return _TransactionBatch(
      transactions: transactions,
      lastFetchedDocument: snapshot.docs.isEmpty ? null : snapshot.docs.last,
    );
  }

  Future<int> _countTransactions({
    required List<String> walletIds,
    required TransactionType? type,
    required TransactionPaidStatusFilter paidStatusFilter,
    required String? counterpartySuffixQuery,
    required TransactionDateRange? dateRange,
  }) async {
    final counts = await Future.wait(
      walletIds.map((walletId) async {
        final query = _support.applyFilters(
          _support.txCollection(walletId),
          type: type,
          paidStatusFilter: paidStatusFilter,
          counterpartySuffixQuery: counterpartySuffixQuery,
          dateRange: dateRange,
        );
        final snapshot = await query.count().get();
        return snapshot.count ?? 0;
      }),
    );

    return counts.fold<int>(0, (total, itemCount) => total + itemCount);
  }

  int _resolveBatchSize(int limit) {
    if (limit <= 0) {
      return 1;
    }
    if (limit < 5) {
      return limit;
    }
    return 5;
  }

  bool _isTransactionAfter(TransactionDto left, TransactionDto right) {
    final dateComparison = left.createdAt.compareTo(right.createdAt);
    if (dateComparison != 0) {
      return dateComparison > 0;
    }

    return left.id.compareTo(right.id) > 0;
  }
}

final class _WalletTransactionState {
  _WalletTransactionState({
    required this.walletId,
    required this.provider,
    required this.phoneNumber,
    required this.ownerUid,
    this.resumeCursor,
  });

  final String walletId;
  final WalletProvider provider;
  final String phoneNumber;
  final String ownerUid;
  final WalletTransactionsPageCursor? resumeCursor;
  final List<TransactionDto> pendingTransactions = <TransactionDto>[];
  QueryDocumentSnapshot<Map<String, dynamic>>? lastFetchedDocument;
  WalletTransactionsPageCursor? consumedCursor;
  bool exhausted = false;
}

final class _TransactionBatch {
  const _TransactionBatch({
    required this.transactions,
    required this.lastFetchedDocument,
  });

  final List<TransactionDto> transactions;
  final QueryDocumentSnapshot<Map<String, dynamic>>? lastFetchedDocument;
}

final class _WalletTransactionCandidate {
  const _WalletTransactionCandidate({
    required this.state,
    required this.transaction,
  });

  final _WalletTransactionState state;
  final TransactionDto transaction;
}
