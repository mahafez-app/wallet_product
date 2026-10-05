import 'package:mahafez_core/mahafez_core.dart';
import '../../domain/entities/missing_transactions_preview.dart';

enum TransactionSyncStatus {
  idle,
  loading,
  ready,
  saving,
  success,
  failure,
}

final class TransactionSyncState {
  const TransactionSyncState({
    this.status = TransactionSyncStatus.idle,
    this.preview,
    this.selectedTransactionIds = const <String>{},
    this.failure,
    this.syncedCount = 0,
  });

  final TransactionSyncStatus status;
  final MissingTransactionsPreview? preview;
  final Set<String> selectedTransactionIds;
  final Failure? failure;
  final int syncedCount;

  bool get isBusy =>
      status == TransactionSyncStatus.loading ||
      status == TransactionSyncStatus.saving;

  TransactionSyncState copyWith({
    TransactionSyncStatus? status,
    MissingTransactionsPreview? preview,
    Set<String>? selectedTransactionIds,
    Failure? failure,
    int? syncedCount,
    bool clearPreview = false,
    bool clearFailure = false,
  }) {
    return TransactionSyncState(
      status: status ?? this.status,
      preview: clearPreview ? null : preview ?? this.preview,
      selectedTransactionIds:
          selectedTransactionIds ?? this.selectedTransactionIds,
      failure: clearFailure ? null : failure ?? this.failure,
      syncedCount: syncedCount ?? this.syncedCount,
    );
  }
}
