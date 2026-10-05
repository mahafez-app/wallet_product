import '../entities/transaction_report_entity.dart';
import 'package:mahafez_core/mahafez_core.dart';

abstract interface class TransactionReportRepository {
  Future<Result<TransactionReportEntity>> getReport({
    required List<String> walletIds,
    required DateTime startDate,
    required DateTime endDate,
  });
}
