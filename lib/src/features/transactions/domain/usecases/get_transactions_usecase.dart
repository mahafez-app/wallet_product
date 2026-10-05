import 'package:mahafez_core/mahafez_core.dart';

import '../entities/transaction_date_range.dart';
import '../entities/transaction_page.dart';
import '../entities/transaction_paid_status_filter.dart';
import '../repositories/transaction_repository.dart';

final class GetTransactionsUseCase
    implements UseCase<TransactionPage, GetTransactionsParams> {
  const GetTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<TransactionPage>> call(GetTransactionsParams params) =>
      _repository.getTransactions(
        walletIds: params.walletIds,
        type: params.type,
        paidStatusFilter: params.paidStatusFilter,
        counterpartySuffixQuery: params.counterpartySuffixQuery,
        dateRange: params.dateRange,
        limit: params.limit,
        cursor: params.cursor,
      );
}

final class GetTransactionsParams {
  const GetTransactionsParams({
    required this.walletIds,
    this.type,
    this.paidStatusFilter = TransactionPaidStatusFilter.all,
    this.counterpartySuffixQuery,
    this.dateRange,
    this.limit = 20,
    this.cursor,
  });

  final List<String> walletIds;
  final TransactionType? type;
  final TransactionPaidStatusFilter paidStatusFilter;
  final String? counterpartySuffixQuery;
  final TransactionDateRange? dateRange;
  final int limit;
  final TransactionsPageCursor? cursor;
}
