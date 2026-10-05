import '../entities/transaction_entity.dart';
import 'package:mahafez_core/mahafez_core.dart';
import '../repositories/transaction_repository.dart';

final class WatchTransactionUseCase
    implements StreamUseCase<TransactionEntity, WatchTransactionParams> {
  const WatchTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Stream<Result<TransactionEntity>> call(WatchTransactionParams params) {
    return _repository.watchTransaction(
      walletId: params.walletId,
      transactionId: params.transactionId,
    );
  }
}

final class WatchTransactionParams {
  const WatchTransactionParams({
    required this.walletId,
    required this.transactionId,
  });

  final String walletId;
  final String transactionId;
}
