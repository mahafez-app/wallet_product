import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahafez_core/mahafez_core.dart';

import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/manual_transaction_assessment.dart';
import '../../domain/usecases/process_manual_transaction_usecase.dart';
import '../../domain/usecases/save_transaction_usecase.dart';
import 'transaction_providers.dart';
import 'manual_transaction_state.dart';

final manualTransactionControllerProvider = NotifierProvider.autoDispose
    .family<
      ManualTransactionController,
      ManualTransactionState,
      String
    >(ManualTransactionController.new);

class ManualTransactionController
    extends Notifier<ManualTransactionState> {
  ManualTransactionController(this._walletId);

  final String _walletId;

  @override
  ManualTransactionState build() => const ManualTransactionState();

  Future<void> analyze(String message) async {
    state = state.copyWith(
      status: ManualTransactionStatus.analyzing,
      clearAssessment: true,
      clearFailure: true,
      clearSavedTransaction: true,
    );

    final result =
        await ref.read(processManualTransactionUseCaseProvider)(
          ProcessManualTransactionParams(
            walletId: _walletId,
            message: message,
            smsReceivedAt: DateTime.now(),
          ),
        );

    await result.fold(_setFailure, (assessment) async {
      if (assessment.requiresReview) {
        state = state.copyWith(
          status: ManualTransactionStatus.reviewRequired,
          assessment: assessment,
        );
        return;
      }

      await _save(assessment.transaction, assessment: assessment);
    });
  }

  Future<void> preview(String message) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) {
      state = state.copyWith(
        status: ManualTransactionStatus.idle,
        clearAssessment: true,
        clearFailure: true,
      );
      return;
    }

    final result =
        await ref.read(processManualTransactionUseCaseProvider)(
          ProcessManualTransactionParams(
            walletId: _walletId,
            message: trimmedMessage,
            smsReceivedAt: DateTime.now(),
          ),
        );

    result.fold(
      (failure) =>
          state = state.copyWith(failure: failure, clearAssessment: true),
      (assessment) =>
          state = state.copyWith(assessment: assessment, clearFailure: true),
    );
  }

  Future<void> confirmSelectedWalletSave() async {
    final assessment = state.assessment;
    if (assessment == null || !assessment.allowsSaveToSelectedWallet) {
      return;
    }

    await _save(assessment.transaction, assessment: assessment);
  }

  void resetTransientState() {
    if (state.status == ManualTransactionStatus.idle &&
        state.assessment == null &&
        state.failure == null) {
      return;
    }

    state = const ManualTransactionState();
  }

  Future<void> _save(
    TransactionEntity transaction, {
    required ManualTransactionAssessment assessment,
  }) async {
    state = state.copyWith(
      status: ManualTransactionStatus.saving,
      assessment: assessment,
      clearFailure: true,
      clearSavedTransaction: true,
    );

    final result = await ref.read(saveTransactionUseCaseProvider)(
      SaveTransactionParams(
        transaction: transaction,
        allowLocallyDeletedRestore: true,
      ),
    );
    result.fold(
      _setFailure,
      (_) => state = state.copyWith(
        status: ManualTransactionStatus.success,
        savedTransaction: transaction,
      ),
    );
  }

  Future<void> _setFailure(Failure failure) async {
    state = state.copyWith(
      status: ManualTransactionStatus.failure,
      failure: failure,
      clearSavedTransaction: true,
    );
  }
}
