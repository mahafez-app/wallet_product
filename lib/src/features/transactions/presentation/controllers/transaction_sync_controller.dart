import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahafez_core/mahafez_core.dart';

import '../../domain/usecases/preview_missing_transactions_usecase.dart';
import '../../domain/usecases/save_transaction_usecase.dart';
import 'transaction_providers.dart';
import 'transaction_sync_state.dart';

final transactionSyncControllerProvider = NotifierProvider.autoDispose
    .family<
      TransactionSyncController,
      TransactionSyncState,
      String
    >(TransactionSyncController.new);

class TransactionSyncController
    extends Notifier<TransactionSyncState> {
  TransactionSyncController(this._walletId);

  final String _walletId;

  @override
  TransactionSyncState build() => const TransactionSyncState();

  Future<void> loadPreview() async {
    if (state.status == TransactionSyncStatus.loading ||
        state.status == TransactionSyncStatus.saving) {
      return;
    }

    state = state.copyWith(
      status: TransactionSyncStatus.loading,
      clearFailure: true,
      syncedCount: 0,
    );

    final result = await ref.read(
      previewMissingTransactionsUseCaseProvider,
    )(PreviewMissingTransactionsParams(walletId: _walletId));

    result.fold(
      (failure) => state = state.copyWith(
        status: TransactionSyncStatus.failure,
        failure: failure,
      ),
      (preview) => state = state.copyWith(
        status: TransactionSyncStatus.ready,
        preview: preview,
        selectedTransactionIds: preview.transactions
            .map((transaction) => transaction.id)
            .toSet(),
        clearFailure: true,
      ),
    );
  }

  void toggleTransaction(String transactionId) {
    if (state.isBusy) return;

    final updatedSelection = Set<String>.of(state.selectedTransactionIds);
    if (!updatedSelection.add(transactionId)) {
      updatedSelection.remove(transactionId);
    }

    state = state.copyWith(selectedTransactionIds: updatedSelection);
  }

  Future<void> saveSelectedTransactions() async {
    final preview = state.preview;
    if (preview == null || state.selectedTransactionIds.isEmpty) {
      return;
    }

    state = state.copyWith(
      status: TransactionSyncStatus.saving,
      clearFailure: true,
      syncedCount: 0,
    );

    final selectedTransactions =
        preview.transactions
            .where(
              (transaction) =>
                  state.selectedTransactionIds.contains(transaction.id),
            )
            .toList(growable: false)
          ..sort((left, right) => left.createdAt.compareTo(right.createdAt));

    var syncedCount = 0;
    for (final transaction in selectedTransactions) {
      final result = await ref.read(saveTransactionUseCaseProvider)(
        SaveTransactionParams(
          transaction: transaction,
          allowLocallyDeletedRestore: true,
        ),
      );
      final failure = result.fold<Failure?>((failure) => failure, (_) => null);
      if (failure == null || _isAlreadyExistsFailure(failure)) {
        syncedCount += 1;
        continue;
      }

      state = state.copyWith(
        status: TransactionSyncStatus.failure,
        failure: failure,
        syncedCount: syncedCount,
      );
      return;
    }

    state = state.copyWith(
      status: TransactionSyncStatus.success,
      syncedCount: syncedCount,
    );
  }

  bool _isAlreadyExistsFailure(Failure failure) {
    return failure is ValidationFailure &&
        failure.code == 'transaction-already-exists';
  }
}
