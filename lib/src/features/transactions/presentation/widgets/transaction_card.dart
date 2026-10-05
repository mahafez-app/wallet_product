import 'package:flutter/material.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../../../shared/utils/amount_extension.dart';
import '../../../../shared/utils/date_extensions.dart';
import '../../../../shared/utils/localization_extension.dart';
import '../../../../shared/utils/provider_ext.dart';
import '../../../../shared/widgets/provider_icon.dart';
import '../../domain/entities/transaction_entity.dart';
import 'transaction_info_chip.dart';


class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.transaction,
    this.showProviderInfo = true,
  });

  final TransactionEntity transaction;
  final bool showProviderInfo;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = context.mahafezColors;

    final isReceive = transaction.type == TransactionType.receive;
    final typeColor = isReceive ? colors.success : colors.danger;
    final counterparty = transaction.counterpartyNumber;
    final formattedDateTime = transaction.createdAt.toTransactionDateTimeLabel(
      context,
    );

    return Container(
      margin: MahafezResponsive.onlyPadding(bottom: MahafezSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(28.responsiveRadius),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(50),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52.responsiveRadius,
            height: 52.responsiveRadius,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [typeColor.withAlpha(40), typeColor.withAlpha(10)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.responsiveRadius),
            ),
            child: Icon(
              isReceive
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: typeColor,
              size: 24.responsiveRadius,
            ),
          ),
          MahafezSpacing.md.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        isReceive
                            ? l10n.transactionTypeReceive
                            : l10n.transactionTypeSend,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    Text(
                      transaction.amount.toCurrencyText(
                        context,
                        sign: isReceive ? '+' : '-',
                        decimalDigits: 0
                      ),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: typeColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                MahafezSpacing.xs.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 14.responsiveRadius,
                      color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
                    ),
                    MahafezSpacing.xs.horizontalSpace,
                    Text(
                      formattedDateTime,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withAlpha(
                          180,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                MahafezSpacing.md.verticalSpace,
                const Divider(height: 1, thickness: 0.5),
                MahafezSpacing.md.verticalSpace,
                if (showProviderInfo) ...[
                  TransactionInfoChip(
                    leading: ProviderIcon(
                      provider: transaction.provider,
                      size: 20.responsiveRadius,
                    ),
                    leadingBackgroundColor: Colors.transparent,
                    label: l10n.walletLabel,
                    value:
                        '${transaction.provider.displayName(context)} · ${EgyptianPhoneNumber.formatForDisplay(transaction.phoneNumber)}',
                  ),
                ],
                if (counterparty != null) ...[
                  MahafezSpacing.xs.verticalSpace,
                  TransactionInfoChip(
                    leading: Icon(
                      Icons.person_rounded,
                      size: 14.responsiveRadius,
                      color: theme.colorScheme.primary,
                    ),
                    leadingBackgroundColor: theme.colorScheme.primary.withAlpha(
                      20,
                    ),
                    label: isReceive
                        ? l10n.transaction_receivedFrom
                        : l10n.transaction_sentTo,
                    value: counterparty,
                  ),
                ],
                if (isReceive) ...[
                  MahafezSpacing.xs.verticalSpace,
                  TransactionInfoChip(
                    leading: Icon(
                      (transaction.isPaid ?? false)
                          ? Icons.check_circle_rounded
                          : Icons.hourglass_empty_rounded,
                      size: 14.responsiveRadius,
                      color: (transaction.isPaid ?? false)
                          ? colors.success
                          : colors.warning,
                    ),
                    leadingBackgroundColor: (transaction.isPaid ?? false)
                        ? colors.success.withAlpha(20)
                        : colors.warning.withAlpha(20),
                    label: l10n.paymentStatus,
                    value: (transaction.isPaid ?? false)
                        ? l10n.transactionStatusPaid
                        : l10n.transactionStatusUnpaid,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
