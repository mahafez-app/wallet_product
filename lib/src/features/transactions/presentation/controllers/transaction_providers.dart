import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:sms_engine/sms_engine.dart';

import '../../../wallets/presentation/controllers/wallet_providers.dart';
import '../../data/datasources/deleted_transaction_local_data_source.dart';
import '../../data/datasources/transaction_cache_local_data_source.dart';
import '../../data/datasources/transaction_firestore_support.dart';
import '../../data/datasources/transaction_watch_remote_data_source.dart';
import '../../data/datasources/wallet_transaction_remote_data_source.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/entities/transaction_page.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/delete_transaction_usecase.dart';
import '../../domain/usecases/get_latest_transaction_date_usecase.dart';
import '../../domain/usecases/get_wallet_transactions_usecase.dart';
import '../../domain/usecases/mark_paid_usecases.dart';
import '../../domain/usecases/note_usecases.dart';
import '../../domain/usecases/preview_missing_transactions_usecase.dart';
import '../../domain/usecases/process_manual_transaction_usecase.dart';
import '../../domain/usecases/save_transaction_usecase.dart';
import '../../domain/usecases/watch_transaction_usecase.dart';

// ── Injected External Hive Boxes ─────────────────────────────────────────────

final transactionCacheBoxProvider = Provider<Box<String>>((ref) {
  throw UnimplementedError(
    'Override transactionCacheBoxProvider with an opened Hive box in ProviderScope',
  );
});

final deletedTransactionsBoxProvider = Provider<Box<String>>((ref) {
  throw UnimplementedError(
    'Override deletedTransactionsBoxProvider with an opened Hive box in ProviderScope',
  );
});

final inboxSmsServiceProvider = Provider<InboxSmsService>((ref) {
  return const InboxSmsServiceImpl();
});

// ── Infrastructure ───────────────────────────────────────────────────────────

final transactionFirestoreSupportProvider = Provider<TransactionFirestoreSupport>(
  (ref) => TransactionFirestoreSupport(
    firestore: ref.watch(walletFirestoreProvider),
    metaCache: ref.watch(walletMetaCacheProvider),
  ),
);

final transactionWatchRemoteDataSourceProvider =
    Provider<TransactionWatchRemoteDataSource>((ref) {
  return TransactionWatchRemoteDataSourceImpl(
    support: ref.watch(transactionFirestoreSupportProvider),
  );
});

final walletTransactionRemoteDataSourceProvider =
    Provider<WalletTransactionRemoteDataSource>((ref) {
  return WalletTransactionRemoteDataSourceImpl(
    support: ref.watch(transactionFirestoreSupportProvider),
  );
});

final transactionCacheLocalDataSourceProvider =
    Provider<TransactionCacheLocalDataSource>(
  (ref) => TransactionCacheLocalDataSourceImpl(
    box: ref.watch(transactionCacheBoxProvider),
  ),
);

final deletedTransactionLocalDataSourceProvider =
    Provider<DeletedTransactionLocalDataSource>(
  (ref) => DeletedTransactionLocalDataSourceImpl(
    box: ref.watch(deletedTransactionsBoxProvider),
  ),
);

// ── Repository ────────────────────────────────────────────────────────────────

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl(
    transactionWatchRemoteDataSource:
        ref.watch(transactionWatchRemoteDataSourceProvider),
    walletRemoteDataSource:
        ref.watch(walletTransactionRemoteDataSourceProvider),
    cacheDataSource: ref.watch(transactionCacheLocalDataSourceProvider),
    deletedTransactionLocalDataSource:
        ref.watch(deletedTransactionLocalDataSourceProvider),
    walletRepository: ref.watch(walletRepositoryProvider),
    inboxSmsService: ref.watch(inboxSmsServiceProvider),
  );
});

// ── Use cases ────────────────────────────────────────────────────────────────

final saveTransactionUseCaseProvider = Provider<SaveTransactionUseCase>((ref) {
  return SaveTransactionUseCase(ref.watch(transactionRepositoryProvider));
});

final getLatestTransactionDateUseCaseProvider =
    Provider<GetLatestTransactionDateUseCase>(
  (ref) => GetLatestTransactionDateUseCase(
    ref.watch(transactionRepositoryProvider),
  ),
);

final deleteTransactionUseCaseProvider = Provider<DeleteTransactionUseCase>((ref) {
  return DeleteTransactionUseCase(ref.watch(transactionRepositoryProvider));
});

final getWalletTransactionsUseCaseProvider =
    Provider<GetWalletTransactionsUseCase>((ref) {
  return GetWalletTransactionsUseCase(
    ref.watch(transactionRepositoryProvider),
  );
});

final previewMissingTransactionsUseCaseProvider =
    Provider<PreviewMissingTransactionsUseCase>((ref) {
  return PreviewMissingTransactionsUseCase(
    ref.watch(transactionRepositoryProvider),
  );
});

final processManualTransactionUseCaseProvider =
    Provider<ProcessManualTransactionUseCase>((ref) {
  return ProcessManualTransactionUseCase(ref.watch(walletRepositoryProvider));
});

final markPaidUseCaseProvider = Provider<MarkAsPaidUseCase>((ref) {
  return MarkAsPaidUseCase(ref.watch(transactionRepositoryProvider));
});

final markAsPaidUseCaseProvider = markPaidUseCaseProvider;

final markUnpaidUseCaseProvider = Provider<MarkAsUnpaidUseCase>((ref) {
  return MarkAsUnpaidUseCase(ref.watch(transactionRepositoryProvider));
});

final markAsUnpaidUseCaseProvider = markUnpaidUseCaseProvider;

final addNoteUseCaseProvider = Provider<AddNoteUseCase>((ref) {
  return AddNoteUseCase(ref.watch(transactionRepositoryProvider));
});

final editNoteUseCaseProvider = Provider<EditNoteUseCase>((ref) {
  return EditNoteUseCase(ref.watch(transactionRepositoryProvider));
});

final deleteNoteUseCaseProvider = Provider<DeleteNoteUseCase>((ref) {
  return DeleteNoteUseCase(ref.watch(transactionRepositoryProvider));
});

final getNotesUseCaseProvider = Provider<GetNotesUseCase>((ref) {
  return GetNotesUseCase(ref.watch(transactionRepositoryProvider));
});

final getTransactionHistoryUseCaseProvider =
    Provider<GetTransactionHistoryUseCase>((ref) {
  return GetTransactionHistoryUseCase(
    ref.watch(transactionRepositoryProvider),
  );
});

final watchTransactionUseCaseProvider = Provider<WatchTransactionUseCase>((ref) {
  return WatchTransactionUseCase(ref.watch(transactionRepositoryProvider));
});

final transactionFirstPageCacheProvider = FutureProvider.autoDispose
    .family<TransactionPage?, String>((ref, walletId) async {
  final cached = await ref
      .read(transactionCacheLocalDataSourceProvider)
      .getFirstPage(walletId);
  if (cached == null) return null;
  return cached.toEntity();
});

