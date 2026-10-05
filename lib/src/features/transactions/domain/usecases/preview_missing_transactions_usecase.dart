import 'package:mahafez_core/mahafez_core.dart';

import '../entities/missing_transactions_preview.dart';
import '../repositories/transaction_repository.dart';

final class PreviewMissingTransactionsParams {
  const PreviewMissingTransactionsParams({required this.walletId});

  final String walletId;
}

/// Thin Clean Architecture usecase delegating directly to repository.
final class PreviewMissingTransactionsUseCase
    implements
        UseCase<
          MissingTransactionsPreview,
          PreviewMissingTransactionsParams
        > {
  const PreviewMissingTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<MissingTransactionsPreview>> call(
    PreviewMissingTransactionsParams params,
  ) {
    return _repository.previewMissingTransactions(params.walletId);
  }
}
