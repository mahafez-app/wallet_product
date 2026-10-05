// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';
import '../../../wallets/presentation/controllers/wallet_details_controller.dart'
    show walletDetailsControllerProvider;

import '../../domain/entities/transaction_entity.dart';
import '../../../../shared/utils/amount_extension.dart';
import '../../../../shared/utils/date_extensions.dart';
import '../../../../shared/utils/localization_extension.dart';
import '../../domain/entities/missing_transactions_preview.dart';
import '../controllers/recent_transactions_provider.dart';
import '../controllers/transaction_sync_controller.dart';
import '../controllers/transaction_sync_state.dart';

class TransactionSyncBottomSheetBody extends ConsumerStatefulWidget {
  const TransactionSyncBottomSheetBody({
    super.key,
    required this.walletId,
  });

  final String walletId;

  @override
  ConsumerState<TransactionSyncBottomSheetBody> createState() =>
      _TransactionSyncBottomSheetBodyState();
}

class _TransactionSyncBottomSheetBodyState
    extends ConsumerState<TransactionSyncBottomSheetBody> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref
          .read(
            transactionSyncControllerProvider(widget.walletId).notifier,
          )
          .loadPreview(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<TransactionSyncState>(
      transactionSyncControllerProvider(widget.walletId),
      (previous, next) {
        final hasNewFailure = previous?.failure != next.failure;
        if (hasNewFailure && next.failure != null && context.mounted) {
          MahafezSnackbar.showFailure(context, failure: next.failure!);
        }

        final wasSuccessful =
            previous?.status != TransactionSyncStatus.success &&
            next.status == TransactionSyncStatus.success;
        if (wasSuccessful) {
          ref.invalidate(walletDetailsControllerProvider(widget.walletId));
          ref.invalidate(recentTransactionsProvider(widget.walletId));
          MahafezSnackbar.show(
            context,
            message: context.l10n.walletSyncTransactionsSavedSuccess(
              next.syncedCount,
            ),
            type: MahafezSnackbarType.success,
          );
          Navigator.of(context).pop();
        }
      },
    );

    final state = ref.watch(
      transactionSyncControllerProvider(widget.walletId),
    );
    final preview = state.preview;

    return Padding(
      padding: MahafezSpacing.pagePadding,
      child: SafeArea(child: _buildBody(state, preview)),
    );
  }

  Widget _buildBody(
    TransactionSyncState state,
    MissingTransactionsPreview? preview,
  ) {
    if (state.status == TransactionSyncStatus.loading) {
      return const _SyncLoadingView();
    }

    if (state.status == TransactionSyncStatus.failure &&
        preview == null) {
      return _SyncLoadFailureView(
        failure: state.failure!,
        onRetry: () => ref
            .read(
              transactionSyncControllerProvider(widget.walletId).notifier,
            )
            .loadPreview(),
      );
    }

    return _SyncContent(
      walletId: widget.walletId,
      state: state,
      preview: preview,
    );
  }
}

class _SyncLoadingView extends StatelessWidget {
  const _SyncLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 220, child: Center(child: MahafezLoader()));
  }
}

class _SyncLoadFailureView extends StatelessWidget {
  const _SyncLoadFailureView({
    super.key,
    required this.failure,
    required this.onRetry,
  });

  final Object failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MahafezErrorView(error: failure),
        MahafezSpacing.lg.verticalSpace,
        Row(
          children: [
            Expanded(
              child: MahafezButton(
                label: context.l10n.commonCancelAction,
                type: MahafezButtonType.secondary,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            MahafezSpacing.md.horizontalSpace,
            Expanded(
              child: MahafezButton(
                label: context.l10n.startupFallbackRetryAction,
                onPressed: onRetry,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SyncContent extends ConsumerWidget {
  const _SyncContent({
    super.key,
    required this.walletId,
    required this.state,
    required this.preview,
  });

  final String walletId;
  final TransactionSyncState state;
  final MissingTransactionsPreview? preview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolvedPreview = preview;
    if (resolvedPreview == null || resolvedPreview.transactions.isEmpty) {
      return _SyncEmptyView(fromDate: preview?.fromDate);
    }

    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.walletSyncTransactionsReviewTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        MahafezSpacing.xs.verticalSpace,
        Text(
          context.l10n.walletSyncTransactionsFoundCount(resolvedPreview.count),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (resolvedPreview.fromDate != null) ...[
          MahafezSpacing.xs.verticalSpace,
          Text(
            context.l10n.walletSyncTransactionsFromDate(
              resolvedPreview.fromDate!.toTransactionDateTimeLabel(context),
            ),
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        MahafezSpacing.lg.verticalSpace,
        Flexible(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: resolvedPreview.transactions.length,
            separatorBuilder: (_, _) => MahafezSpacing.sm.verticalSpace,
            itemBuilder: (context, index) {
              final transaction = resolvedPreview.transactions[index];
              final isSelected = state.selectedTransactionIds.contains(
                transaction.id,
              );
              return _SyncTransactionTile(
                transaction: transaction,
                isSelected: isSelected,
                onChanged: () => ref
                    .read(
                      transactionSyncControllerProvider(
                        walletId,
                      ).notifier,
                    )
                    .toggleTransaction(transaction.id),
              );
            },
          ),
        ),
        MahafezSpacing.lg.verticalSpace,
        Text(
          context.l10n.walletSyncTransactionsSelectedCount(
            state.selectedTransactionIds.length,
          ),
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        MahafezSpacing.md.verticalSpace,
        Row(
          children: [
            Expanded(
              child: MahafezButton(
                label: context.l10n.commonCancelAction,
                type: MahafezButtonType.secondary,
                onPressed: state.isBusy
                    ? null
                    : () => Navigator.of(context).pop(),
              ),
            ),
            MahafezSpacing.md.horizontalSpace,
            Expanded(
              child: MahafezButton(
                label: context.l10n.walletSyncTransactionsSaveAction,
                isLoading: state.status == TransactionSyncStatus.saving,
                onPressed: state.selectedTransactionIds.isEmpty || state.isBusy
                    ? null
                    : () => ref
                          .read(
                            transactionSyncControllerProvider(
                              walletId,
                            ).notifier,
                          )
                          .saveSelectedTransactions(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SyncEmptyView extends StatelessWidget {
  const _SyncEmptyView({super.key, this.fromDate});

  final DateTime? fromDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 240.responsiveHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.walletSyncTransactionsEmptyTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          MahafezSpacing.sm.verticalSpace,
          Text(
            fromDate == null
                ? context.l10n.walletSyncTransactionsEmptyDescription
                : context.l10n.walletSyncTransactionsEmptySinceDescription(
                    fromDate!.toTransactionDateTimeLabel(context),
                  ),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          MahafezSpacing.lg.verticalSpace,
          MahafezButton(
            label: context.l10n.commonCancelAction,
            type: MahafezButtonType.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _SyncTransactionTile extends StatelessWidget {
  const _SyncTransactionTile({
    super.key,
    required this.transaction,
    required this.isSelected,
    required this.onChanged,
  });

  final TransactionEntity transaction;
  final bool isSelected;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.mahafezColors;
    final isReceive = transaction.type == TransactionType.receive;
    final typeLabel = isReceive
        ? context.l10n.transactionTypeReceive
        : context.l10n.transactionTypeSend;
    final amountSign = isReceive ? '+' : '-';

    return InkWell(
      borderRadius: BorderRadius.circular(20.responsiveRadius),
      onTap: onChanged,
      child: Container(
        padding: MahafezResponsive.allPadding(MahafezSpacing.md),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(20.responsiveRadius),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(value: isSelected, onChanged: (_) => onChanged()),
            MahafezSpacing.sm.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    typeLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  MahafezSpacing.xs.verticalSpace,
                  Text(
                    transaction.amount.toCurrencyText(
                      context,
                      sign: amountSign,
                      decimalDigits: 0,
                    ),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  MahafezSpacing.xs.verticalSpace,
                  Text(
                    transaction.createdAt.toTransactionDateTimeLabel(context),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (transaction.counterpartyNumber != null) ...[
                    MahafezSpacing.xs.verticalSpace,
                    Text(
                      transaction.counterpartyNumber!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
