import '../entities/transaction_date_range.dart';
import 'package:mahafez_core/mahafez_core.dart';
import '../entities/transaction_page.dart';
import '../entities/transaction_paid_status_filter.dart';
import '../repositories/transaction_repository.dart';

final class GetWalletTransactionsUseCase
    implements UseCase<TransactionPage, GetWalletTransactionsParams> {
  const GetWalletTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<TransactionPage>> call(GetWalletTransactionsParams params) =>
      _repository.getWalletTransactions(
        walletId: params.walletId,
        type: params.type,
        paidStatusFilter: params.paidStatusFilter,
        counterpartySuffixQuery: params.counterpartySuffixQuery,
        dateRange: params.dateRange,
        limit: params.limit,
        cursor: params.cursor,
      );
}

final class GetWalletTransactionsParams {
  const GetWalletTransactionsParams({
    required this.walletId,
    this.type,
    this.paidStatusFilter = TransactionPaidStatusFilter.all,
    this.counterpartySuffixQuery,
    this.dateRange,
    this.limit = 20,
    this.cursor,
  });

  final String walletId;
  final TransactionType? type;
  final TransactionPaidStatusFilter paidStatusFilter;
  final String? counterpartySuffixQuery;
  final TransactionDateRange? dateRange;
  final int limit;
  final WalletTransactionsPageCursor? cursor;
}
