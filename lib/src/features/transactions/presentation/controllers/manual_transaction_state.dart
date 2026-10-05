import '../../domain/entities/transaction_entity.dart';
import 'package:mahafez_core/mahafez_core.dart';
import '../../domain/entities/manual_transaction_assessment.dart';

enum ManualTransactionStatus {
  idle,
  analyzing,
  reviewRequired,
  saving,
  success,
  failure,
}

final class ManualTransactionState {
  const ManualTransactionState({
    this.status = ManualTransactionStatus.idle,
    this.assessment,
    this.failure,
    this.savedTransaction,
  });

  final ManualTransactionStatus status;
  final ManualTransactionAssessment? assessment;
  final Failure? failure;
  final TransactionEntity? savedTransaction;

  bool get isBusy =>
      status == ManualTransactionStatus.analyzing ||
      status == ManualTransactionStatus.saving;

  ManualTransactionState copyWith({
    ManualTransactionStatus? status,
    ManualTransactionAssessment? assessment,
    Failure? failure,
    TransactionEntity? savedTransaction,
    bool clearAssessment = false,
    bool clearFailure = false,
    bool clearSavedTransaction = false,
  }) {
    return ManualTransactionState(
      status: status ?? this.status,
      assessment: clearAssessment ? null : assessment ?? this.assessment,
      failure: clearFailure ? null : failure ?? this.failure,
      savedTransaction: clearSavedTransaction
          ? null
          : savedTransaction ?? this.savedTransaction,
    );
  }
}
