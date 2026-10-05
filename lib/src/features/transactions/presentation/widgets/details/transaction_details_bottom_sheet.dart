// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mahafez_core/mahafez_core.dart';
import '../../../../../shared/utils/failure_mapper.dart';
import '../../../../../shared/utils/failure_extension.dart';
import '../../../../../shared/utils/localization_extension.dart';
import '../../../../../shared/utils/transaction_share_extension.dart';
import '../../../../wallets/presentation/controllers/wallet_providers.dart';
import '../../controllers/transaction_events_provider.dart';
import '../../controllers/share_receipt_controller.dart';
import '../../controllers/transaction_details_controller.dart';
import '../../controllers/transaction_details_state.dart';
import '../../../domain/entities/transaction_entity.dart';
import 'details_card_section.dart';
import 'notes_section.dart';
import 'sms_section.dart';
import 'transaction_header_section.dart';
import 'transaction_history_section.dart';
import 'transaction_receipt_capture_service.dart';

class TransactionDetailsBottomSheet extends ConsumerWidget {
  const TransactionDetailsBottomSheet({super.key, required this.transaction});

  final TransactionEntity transaction;

  static Future<void> show(
    BuildContext context,
    TransactionEntity transaction,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TransactionDetailsBottomSheet(transaction: transaction),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.97,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28.responsiveRadius),
            ),
          ),
          child: Column(
            children: [
              _BottomSheetHandle(theme: theme),
              Expanded(
                child: _DetailsScrollContent(
                  transaction: transaction,
                  scrollController: scrollController,
                ),
              ),
              _DetailsActionBar(transaction: transaction),
              MahafezSpacing.lg.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

// ── Drag handle ───────────────────────────────────────────────────────────────

class _BottomSheetHandle extends StatelessWidget {
  const _BottomSheetHandle({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MahafezResponsive.symmetricPadding(vertical: MahafezSpacing.md),
      child: Center(
        child: Container(
          width: 40.responsiveWidth,
          height: 4.responsiveHeight,
          decoration: BoxDecoration(
            color: theme.colorScheme.outlineVariant.withAlpha(120),
            borderRadius: BorderRadius.circular(4.responsiveRadius),
          ),
        ),
      ),
    );
  }
}

// ── Scrollable body ───────────────────────────────────────────────────────────

class _DetailsScrollContent extends ConsumerWidget {
  const _DetailsScrollContent({
    super.key,
    required this.transaction,
    required this.scrollController,
  });

  final TransactionEntity transaction;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionDetailsControllerProvider(transaction));

    ref.listen(transactionDetailsControllerProvider(transaction), (
      previous,
      next,
    ) {
      final actionError = next.actionError;
      if (actionError == null || previous?.actionError == actionError) return;
      MahafezSnackbar.show(
        context,
        message: actionError.toLocalizedString(context),
        type: MahafezSnackbarType.error,
      );
    });
    ref.listen<TransactionEvent?>(transactionUpdatesProvider, (_, next) {
      if (next case TransactionDeletedEvent(
        :final walletId,
        :final transactionId,
      )) {
        final isCurrentTransaction =
            walletId == transaction.walletId && transactionId == transaction.id;
        if (!isCurrentTransaction) return;

        MahafezSnackbar.show(
          context,
          message: context.l10n.transaction_deletedSuccess,
          type: MahafezSnackbarType.success,
        );
        Navigator.of(context).pop();
      }
    });

    return ListView(
      controller: scrollController,
      padding: MahafezSpacing.pagePadding,
      children: [
        TransactionHeaderSection(transaction: state.transaction),
        MahafezSpacing.lg.verticalSpace,
        DetailsCardSection(
          transaction: state.transaction,
          controllerTransaction: transaction,
        ),
        MahafezSpacing.xl.verticalSpace,
        if (state.transaction.message != null) ...[
          SmsSection(message: state.transaction.message!),
          MahafezSpacing.xl.verticalSpace,
        ],
        NotesSection(transaction: state.transaction),
        MahafezSpacing.xl.verticalSpace,
        if (state.history.isNotEmpty)
          TransactionHistorySection(entries: state.history),
        MahafezSpacing.xl.verticalSpace,
      ],
    );
  }
}

// ── Bottom action bar (share + delete) ───────────────────────────────────────

class _DetailsActionBar extends ConsumerWidget {
  const _DetailsActionBar({super.key, required this.transaction});

  final TransactionEntity transaction;

  static const TransactionReceiptCaptureService _captureService =
      TransactionReceiptCaptureService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ref.listen<AsyncValue<void>>(
      shareReceiptControllerProvider,
      (previous, next) => _handleShareStateChange(context, previous, next),
    );

    final detailsState = ref.watch(
      transactionDetailsControllerProvider(transaction),
    );
    final shareState = ref.watch(shareReceiptControllerProvider);
    final currentUserId = ref.watch(walletCurrentUserProvider)?.uid;
    final canDelete = currentUserId == detailsState.transaction.walletOwnerUid;
    final isDeletingTransaction =
        detailsState.currentAction ==
        TransactionDetailsAction.deletingTransaction;

    return Container(
      padding: MahafezResponsive.symmetricPadding(
        horizontal: MahafezSpacing.lg,
        vertical: MahafezSpacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withAlpha(60),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: shareState.isLoading
                  ? null
                  : () => _share(context: context, ref: ref),
              icon: shareState.isLoading
                  ? SizedBox(
                      width: 20.responsiveRadius,
                      height: 20.responsiveRadius,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.share_rounded),
              label: Text(context.l10n.transaction_shareReceipt),
              style: FilledButton.styleFrom(
                padding: MahafezResponsive.symmetricPadding(
                  vertical: MahafezSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.responsiveRadius),
                ),
              ),
            ),
          ),
          if (canDelete) ...[
            MahafezSpacing.sm.horizontalSpace,
            _DeleteIconButton(
              isLoading: isDeletingTransaction,
              onPressed: isDeletingTransaction
                  ? null
                  : () => _confirmDelete(context, ref),
            ),
          ],
        ],
      ),
    );
  }

  void _share({required BuildContext context, required WidgetRef ref}) {
    unawaited(_captureAndShare(context: context, ref: ref));
  }

  Future<void> _captureAndShare({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final detailsState = ref.read(
      transactionDetailsControllerProvider(transaction),
    );
    try {
      final shareMessage = context.l10n.transaction_shareReceipt;
      final receiptBytes = await _captureService.capture(
        context: context,
        transaction: detailsState.transaction,
      );
      if (!context.mounted) return;
      ref
          .read(shareReceiptControllerProvider.notifier)
          .shareReceipt(
            receiptBytes: receiptBytes,
            fileName: detailsState.transaction.receiptFileName,
            shareMessage: shareMessage,
          );
    } catch (error, stackTrace) {
      final failure = const FailureMapper().map(error);
      log(
        'DetailsActionBar.capture: $failure',
        name: 'Presentation',
        error: error,
        stackTrace: stackTrace,
      );
      if (!context.mounted) return;
      MahafezSnackbar.showFailure(context, failure: failure);
    }
  }

  void _handleShareStateChange(
    BuildContext context,
    AsyncValue<void>? previous,
    AsyncValue<void> next,
  ) {
    if (!next.hasError || next.isLoading) return;
    final error = next.error;
    if (previous?.error == error) return;

    final failure = error is Failure
        ? error
        : const UnknownFailure(technicalMessage: 'Unexpected share failure.');
    if (error is! Failure && error != null) {
      log('DetailsActionBar: $error', name: 'Presentation');
    }
    MahafezSnackbar.showFailure(context, failure: failure);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    await MahafezDialog.show<void>(
      context,
      title: context.l10n.transaction_deleteTitle,
      message: context.l10n.transaction_deleteMessage,
      confirmLabel: context.l10n.transaction_deleteAction,
      cancelLabel: context.l10n.transaction_cancel,
      type: MahafezDialogType.error,
      onConfirm: () {
        Navigator.of(context).pop();
        ref
            .read(transactionDetailsControllerProvider(transaction).notifier)
            .deleteTransaction();
      },
      onCancel: () => Navigator.of(context).pop(),
    );
  }
}

class _DeleteIconButton extends StatelessWidget {
  const _DeleteIconButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: context.l10n.transaction_deleteAction,
      child: isLoading
          ? SizedBox.square(
              dimension: 44.responsiveRadius,
              child: Center(
                child: SizedBox.square(
                  dimension: 20.responsiveRadius,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.error,
                  ),
                ),
              ),
            )
          : IconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.delete_outline_rounded),
              color: colorScheme.error,
              style: IconButton.styleFrom(
                foregroundColor: colorScheme.error,
                backgroundColor: colorScheme.errorContainer.withAlpha(80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.responsiveRadius),
                ),
              ),
            ),
    );
  }
}

// ── End of Bottom Sheet ────────────────────────────────────────────────────────
