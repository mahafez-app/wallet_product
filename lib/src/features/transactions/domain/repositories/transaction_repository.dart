import 'package:mahafez_core/mahafez_core.dart';

import '../entities/missing_transactions_preview.dart';
import '../entities/note_entity.dart';
import '../entities/transaction_date_range.dart';
import '../entities/transaction_entity.dart';
import '../entities/transaction_history_entry_entity.dart';
import '../entities/transaction_page.dart';
import '../entities/transaction_paid_status_filter.dart';
import '../entities/transactions_overview_entity.dart';

abstract interface class TransactionRepository {
  Future<Result<TransactionPage>> getTransactions({
    required List<String> walletIds,
    TransactionType? type,
    TransactionPaidStatusFilter paidStatusFilter =
        TransactionPaidStatusFilter.all,
    String? counterpartySuffixQuery,
    TransactionDateRange? dateRange,
    int limit = 20,
    TransactionsPageCursor? cursor,
  });

  Future<Result<TransactionsOverviewEntity>> getTransactionsOverview({
    required List<String> walletIds,
  });

  Future<Result<TransactionPage>> getWalletTransactions({
    required String walletId,
    TransactionType? type,
    TransactionPaidStatusFilter paidStatusFilter =
        TransactionPaidStatusFilter.all,
    String? counterpartySuffixQuery,
    TransactionDateRange? dateRange,
    int limit = 20,
    WalletTransactionsPageCursor? cursor,
  });

  Stream<Result<TransactionEntity>> watchTransaction({
    required String walletId,
    required String transactionId,
  });

  Future<Result<DateTime?>> getLatestTransactionDate(String walletId);

  Future<Result<MissingTransactionsPreview>> previewMissingTransactions(
    String walletId,
  );

  Future<Result<void>> markAsPaid({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
  });

  Future<Result<void>> markAsUnpaid({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
  });

  Future<Result<void>> saveTransaction(
    TransactionEntity transaction, {
    bool allowLocallyDeletedRestore = false,
  });

  Future<Result<void>> deleteTransaction({
    required String walletId,
    required String transactionId,
    required String userId,
  });

  Future<Result<void>> addNote({
    required String walletId,
    required String transactionId,
    required String text,
    required String userId,
    required String userName,
  });

  Future<Result<void>> editNote({
    required String walletId,
    required String transactionId,
    required String noteId,
    required String text,
  });

  Future<Result<void>> deleteNote({
    required String walletId,
    required String transactionId,
    required String noteId,
  });

  Stream<Result<List<NoteEntity>>> getNotes({
    required String walletId,
    required String transactionId,
  });

  Stream<Result<List<TransactionHistoryEntryEntity>>> getTransactionHistory({
    required String walletId,
    required String transactionId,
  });
}
