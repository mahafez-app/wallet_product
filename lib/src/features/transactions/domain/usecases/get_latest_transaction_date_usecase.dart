import 'package:mahafez_core/mahafez_core.dart';
import '../repositories/transaction_repository.dart';

final class GetLatestTransactionDateUseCase
    implements UseCase<DateTime?, GetLatestTransactionDateParams> {
  const GetLatestTransactionDateUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<DateTime?>> call(GetLatestTransactionDateParams params) {
    return _repository.getLatestTransactionDate(params.walletId);
  }
}

final class GetLatestTransactionDateParams {
  const GetLatestTransactionDateParams({required this.walletId});

  final String walletId;
}
