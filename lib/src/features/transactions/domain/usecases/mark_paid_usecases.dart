import 'package:mahafez_core/mahafez_core.dart';
import '../repositories/transaction_repository.dart';

final class MarkAsPaidUseCase implements UseCase<void, MarkPaidParams> {
  const MarkAsPaidUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<void>> call(MarkPaidParams params) => _repository.markAsPaid(
    walletId: params.walletId,
    transactionId: params.transactionId,
    userId: params.userId,
    userName: params.userName,
  );
}

final class MarkAsUnpaidUseCase implements UseCase<void, MarkPaidParams> {
  const MarkAsUnpaidUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<void>> call(MarkPaidParams params) => _repository.markAsUnpaid(
    walletId: params.walletId,
    transactionId: params.transactionId,
    userId: params.userId,
    userName: params.userName,
  );
}

final class MarkPaidParams {
  const MarkPaidParams({
    required this.walletId,
    required this.transactionId,
    required this.userId,
    required this.userName,
  });

  final String walletId;
  final String transactionId;
  final String userId;
  final String userName;
}
