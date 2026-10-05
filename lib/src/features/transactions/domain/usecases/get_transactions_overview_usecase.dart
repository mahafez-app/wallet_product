import 'package:mahafez_core/mahafez_core.dart';

import '../entities/transactions_overview_entity.dart';
import '../repositories/transaction_repository.dart';

final class GetTransactionsOverviewUseCase
    implements UseCase<TransactionsOverviewEntity, List<String>> {
  const GetTransactionsOverviewUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<TransactionsOverviewEntity>> call(List<String> walletIds) =>
      _repository.getTransactionsOverview(walletIds: walletIds);
}
