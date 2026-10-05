import 'package:flutter/material.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../../../shared/utils/amount_extension.dart';
import '../../../../shared/utils/date_extensions.dart';
import '../../../../shared/utils/localization_extension.dart';

import '../../domain/entities/manual_transaction_assessment.dart';

class ManualTransactionSummaryRow extends StatelessWidget {
  const ManualTransactionSummaryRow({
    super.key,
    required this.assessment,
  });

  final ManualTransactionAssessment assessment;

  @override
  Widget build(BuildContext context) {
    final transaction = assessment.transaction;
    final typeLabel = transaction.type.name == 'receive'
        ? context.l10n.transactionTypeReceive
        : context.l10n.transactionTypeSend;
    final amountText = transaction.amount.toCurrencyText(context);
    final balanceText = transaction.statusBalance?.toCurrencyText(context);

    return Wrap(
      spacing: MahafezSpacing.sm.responsiveWidth,
      runSpacing: MahafezSpacing.sm.responsiveHeight,
      children: [
        _SummaryChip(
          label: '$typeLabel • $amountText',
          icon: transaction.type.name == 'receive'
              ? Icons.south_west_rounded
              : Icons.north_east_rounded,
        ),
        _SummaryChip(
          label: transaction.createdAt.toFormattedDate(context),
          icon: Icons.calendar_today_rounded,
        ),
        if (balanceText != null)
          _SummaryChip(
            label: context.l10n.walletManualTransactionBalanceChip(balanceText),
            icon: Icons.account_balance_wallet_rounded,
          ),
        if (assessment.explicitWalletPhone != null)
          _SummaryChip(
            label: context.l10n.walletManualTransactionPhoneChip(
              EgyptianPhoneNumber.formatForDisplay(
                assessment.explicitWalletPhone!,
              ),
            ),
            icon: Icons.phone_android_rounded,
          ),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: MahafezResponsive.symmetricPadding(
        horizontal: MahafezSpacing.md,
        vertical: MahafezSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withAlpha(190),
        borderRadius: BorderRadius.circular(16.responsiveRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18.responsiveRadius,
            color: theme.colorScheme.primary,
          ),
          MahafezSpacing.md.horizontalSpace,
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
