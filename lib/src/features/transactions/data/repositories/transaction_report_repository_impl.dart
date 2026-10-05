import 'dart:developer';

import 'package:mahafez_core/mahafez_core.dart';

import '../../domain/entities/transaction_report_entity.dart';
import '../../domain/repositories/transaction_report_repository.dart';
import '../datasources/transaction_report_remote_data_source.dart';

final class TransactionReportRepositoryImpl
    implements TransactionReportRepository {
  const TransactionReportRepositoryImpl(this._remoteDataSource);

  final TransactionReportRemoteDataSource _remoteDataSource;

  @override
  Future<Result<TransactionReportEntity>> getReport({
    required List<String> walletIds,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      return Success(
        await _remoteDataSource.getReport(
          walletIds: walletIds,
          startDate: startDate,
          endDate: endDate,
        ),
      );
    } on Failure catch (failure) {
      return FailureResult(failure);
    } catch (error, stackTrace) {
      log(
        'Failed to load transaction report: $error',
        name: 'TransactionReportRepository',
        stackTrace: stackTrace,
      );
      return const FailureResult(UnknownFailure());
    }
  }
}
