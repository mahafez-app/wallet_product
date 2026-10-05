import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';
import '../../../wallets/presentation/controllers/wallet_details_controller.dart'
    show walletDetailsControllerProvider;

import '../../../../shared/utils/localization_extension.dart';
import '../../domain/entities/manual_transaction_assessment.dart';
import '../controllers/manual_transaction_controller.dart';
import '../controllers/manual_transaction_state.dart';
import '../controllers/recent_transactions_provider.dart';
import 'manual_transaction_action_section.dart';
import 'manual_transaction_assessment_card.dart';
import 'manual_transaction_input_section.dart';

class ManualTransactionBottomSheetBody extends ConsumerStatefulWidget {
  const ManualTransactionBottomSheetBody({
    super.key,
    required this.walletId,
  });

  final String walletId;

  @override
  ConsumerState<ManualTransactionBottomSheetBody> createState() =>
      _ManualTransactionBottomSheetBodyState();
}

class _ManualTransactionBottomSheetBodyState
    extends ConsumerState<ManualTransactionBottomSheetBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ManualTransactionState>(
      manualTransactionControllerProvider(widget.walletId),
      (previous, next) {
        final hasNewFailure =
            previous?.failure != next.failure &&
            next.status == ManualTransactionStatus.failure;
        if (hasNewFailure && next.failure != null) {
          MahafezSnackbar.showFailure(context, failure: next.failure!);

          final failure = next.failure!;
          final isAlreadyExists = failure is ValidationFailure &&
              failure.code == 'transaction-already-exists';

          if (isAlreadyExists) {
            Navigator.of(context).pop();
          }
        }

        final hasSaved =
            previous?.status != ManualTransactionStatus.success &&
            next.status == ManualTransactionStatus.success;
        if (hasSaved && context.mounted) {
          ref.invalidate(walletDetailsControllerProvider(widget.walletId));
          ref.invalidate(recentTransactionsProvider(widget.walletId));
          MahafezSnackbar.show(
            context,
            message: context.l10n.walletManualTransactionSaved,
            type: MahafezSnackbarType.success,
          );
          Navigator.of(context).pop();
        }
      },
    );

    final state = ref.watch(
      manualTransactionControllerProvider(widget.walletId),
    );
    final hasAssessment = state.assessment != null;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ManualTransactionInputSection(
              messageController: _messageController,
              isCompact: hasAssessment,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.l10n.errorManualTransactionMessageRequired;
                }
                return null;
              },
              onChanged: (value) {
                ref
                    .read(
                      manualTransactionControllerProvider(
                        widget.walletId,
                      ).notifier,
                    )
                    .preview(value);
              },
              onPastePressed: _pasteFromClipboard,
            ),
            if (hasAssessment) ...[
              MahafezSpacing.md.verticalSpace,
              ManualTransactionAssessmentCard(assessment: state.assessment!),
            ],
            MahafezSpacing.xl.verticalSpace,
            ManualTransactionActionSection(
              primaryLabel: _primaryActionLabel(context, state),
              isLoading: state.isBusy,
              onPrimaryPressed: _resolvePrimaryAction(state),
              cancelLabel: context.l10n.commonCancelAction,
              onCancelPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    final pastedText = data?.text?.trim();
    if (pastedText == null || pastedText.isEmpty) {
      if (mounted) {
        MahafezSnackbar.show(
          context,
          message: context.l10n.errorManualTransactionMessageRequired,
          type: MahafezSnackbarType.error,
        );
      }
      return;
    }

    _messageController.text = pastedText;
    ref
        .read(
          manualTransactionControllerProvider(widget.walletId).notifier,
        )
        .preview(pastedText);
  }

  VoidCallback? _resolvePrimaryAction(ManualTransactionState state) {
    if (state.isBusy) {
      return null;
    }

    final assessment = state.assessment;
    if (assessment == null) {
      return _analyzeMessage;
    }

    if (!assessment.allowsSaveToSelectedWallet) {
      return null;
    }

    return () => ref
        .read(
          manualTransactionControllerProvider(widget.walletId).notifier,
        )
        .confirmSelectedWalletSave();
  }

  String _primaryActionLabel(
    BuildContext context,
    ManualTransactionState state,
  ) {
    final assessment = state.assessment;
    if (assessment == null) {
      return context.l10n.walletManualTransactionAnalyzeAction;
    }

    return switch (assessment.reviewKind) {
      ManualTransactionReviewKind.needsConfirmation =>
        context.l10n.walletManualTransactionConfirmAction,
      ManualTransactionReviewKind.inferredWalletMismatch =>
        context.l10n.walletManualTransactionForceAction,
      ManualTransactionReviewKind.explicitWalletMismatch =>
        context.l10n.walletManualTransactionForceAction,
      ManualTransactionReviewKind.none =>
        context.l10n.walletManualTransactionSaveAction,
    };
  }

  void _analyzeMessage() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    ref
        .read(
          manualTransactionControllerProvider(widget.walletId).notifier,
        )
        .analyze(_messageController.text);
  }
}
