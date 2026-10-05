// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mahafez_core/mahafez_core.dart';
import '../../../../../shared/utils/date_extensions.dart';
import '../../../../../shared/utils/localization_extension.dart';
import '../../controllers/transaction_details_controller.dart';
import '../../../domain/entities/transaction_entity.dart';
import 'details_card_row.dart';
import 'paid_status_chip.dart';
import 'transaction_wallet_chip.dart';

/// Details card with wallet, date/time, and (for receive) paid status chips.
class DetailsCardSection extends ConsumerWidget {
  const DetailsCardSection({
    super.key,
    required this.transaction,
    this.controllerTransaction,
    this.isReadOnly = false,
  });

  final TransactionEntity transaction;
  final TransactionEntity? controllerTransaction;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = context.mahafezColors;
    final l10n = context.l10n;
    final dateTimeText = transaction.createdAt.toTransactionDateTimeLabel(
      context,
    );

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(28.responsiveRadius),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(50),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          DetailsCardRow(
            label: l10n.transaction_wallet,
            child: TransactionWalletChip(transaction: transaction),
          ),
          const DetailsCardDivider(),
          if (transaction.counterpartyNumber != null &&
              transaction.counterpartyNumber!.trim().isNotEmpty) ...[
            DetailsCardRow(
              label: transaction.type == TransactionType.receive
                  ? l10n.transaction_receivedFrom
                  : l10n.transaction_sentTo,
              child: Text(
                transaction.counterpartyNumber!,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const DetailsCardDivider(),
          ],
          DetailsCardRow(
            label: l10n.transaction_dateTime,
            child: Text(
              dateTimeText,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          if (transaction.type == TransactionType.receive) ...[
            const DetailsCardDivider(),
            _PaidStatusRow(
              transaction: transaction,
              controllerTransaction: controllerTransaction ?? transaction,
              isReadOnly: isReadOnly,
            ),
          ],
        ],
      ),
    );
  }
}

class _PaidStatusRow extends ConsumerWidget {
  const _PaidStatusRow({
    super.key,
    required this.transaction,
    required this.controllerTransaction,
    required this.isReadOnly,
  });

  final TransactionEntity transaction;
  final TransactionEntity controllerTransaction;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.mahafezColors;
    final controller = isReadOnly
        ? null
        : ref.read(
            transactionDetailsControllerProvider(
              controllerTransaction,
            ).notifier,
          );

    return DetailsCardRow(
      label: context.l10n.paymentStatus,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PaidStatusChip(
            label: context.l10n.transactionStatusPaid,
            isActive: transaction.isPaid ?? false,
            activeColor: colors.success,
            onTap: isReadOnly || (transaction.isPaid ?? false)
                ? null
                : () => controller?.markAsPaid(),
          ),
          MahafezSpacing.sm.horizontalSpace,
          PaidStatusChip(
            label: context.l10n.transactionStatusUnpaid,
            isActive: !(transaction.isPaid ?? false),
            activeColor: colors.danger,
            onTap: isReadOnly || !(transaction.isPaid ?? false)
                ? null
                : () => controller?.markAsUnpaid(),
          ),
        ],
      ),
    );
  }
}
