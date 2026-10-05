import 'package:mahafez_core/mahafez_core.dart';
import '../repositories/transaction_repository.dart';

final class DeleteTransactionParams {
  const DeleteTransactionParams({
    required this.walletId,
    required this.transactionId,
    required this.userId,
  });

  final String walletId;
  final String transactionId;
  final String userId;
}

final class DeleteTransactionUseCase
    implements UseCase<void, DeleteTransactionParams> {
  const DeleteTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<void>> call(DeleteTransactionParams params) {
    return _repository.deleteTransaction(
      walletId: params.walletId,
      transactionId: params.transactionId,
      userId: params.userId,
    );
  }
}
