import '../entities/transaction_entity.dart';
import 'package:mahafez_core/mahafez_core.dart';
import '../repositories/transaction_repository.dart';

final class SaveTransactionParams {
  const SaveTransactionParams({
    required this.transaction,
    this.allowLocallyDeletedRestore = false,
  });

  final TransactionEntity transaction;
  final bool allowLocallyDeletedRestore;
}

final class SaveTransactionUseCase
    implements UseCase<void, SaveTransactionParams> {
  const SaveTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<void>> call(SaveTransactionParams params) {
    return _repository.saveTransaction(
      params.transaction,
      allowLocallyDeletedRestore: params.allowLocallyDeletedRestore,
    );
  }
}
