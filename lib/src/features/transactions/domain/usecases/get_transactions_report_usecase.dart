import 'package:mahafez_core/mahafez_core.dart';

import '../entities/transaction_report_entity.dart';
import '../repositories/transaction_report_repository.dart';

final class GetTransactionsReportUseCase
    implements UseCase<TransactionReportEntity, GetTransactionsReportParams> {
  const GetTransactionsReportUseCase(this._repository);

  final TransactionReportRepository _repository;

  @override
  Future<Result<TransactionReportEntity>> call(
    GetTransactionsReportParams params,
  ) => _repository.getReport(
    walletIds: params.walletIds,
    startDate: params.startDate,
    endDate: params.endDate,
  );
}

final class GetTransactionsReportParams {
  const GetTransactionsReportParams({
    required this.walletIds,
    required this.startDate,
    required this.endDate,
  });

  final List<String> walletIds;
  final DateTime startDate;
  final DateTime endDate;
}
