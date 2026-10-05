import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import 'package:mahafez_core/mahafez_core.dart';
import '../../../../../shared/utils/amount_extension.dart';
import '../../../../../shared/utils/localization_extension.dart';
import '../../../domain/entities/transaction_entity.dart';

/// Centered header: large icon, amount, and transaction type label.
class TransactionHeaderSection extends StatelessWidget {
  const TransactionHeaderSection({super.key, required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.mahafezColors;
    final l10n = context.l10n;
    final isReceive = transaction.type == TransactionType.receive;
    final typeColor = isReceive ? colors.success : colors.danger;
    final sign = isReceive ? '+' : '-';
    final label = isReceive
        ? l10n.transaction_typeReceiveLabel
        : l10n.transaction_typeSendLabel;
    final amountText = '$sign${transaction.amount.toLocalizedAmount(context, decimalDigits: 0)}';

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100.responsiveRadius,
              height: 100.responsiveRadius,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    typeColor.withAlpha(25),
                    typeColor.withAlpha(0),
                  ],
                ),
              ),
            ),
            Container(
              width: 72.responsiveRadius,
              height: 72.responsiveRadius,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    typeColor.withAlpha(40),
                    typeColor.withAlpha(15),
                  ],
                ),
                borderRadius: BorderRadius.circular(22.responsiveRadius),
                border: Border.all(
                  color: typeColor.withAlpha(30),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: typeColor.withAlpha(20),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                isReceive
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: typeColor,
                size: 32.responsiveRadius,
              ),
            ),
          ],
        ),
        MahafezSpacing.lg.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              amountText,
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.5,
                fontSize: 40.responsiveFont,
              ),
            ),
            MahafezSpacing.xs.horizontalSpace,
            Text(
              l10n.currency,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withAlpha(180),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        MahafezSpacing.xs.verticalSpace,
        Container(
          padding: MahafezResponsive.symmetricPadding(
            horizontal: MahafezSpacing.md,
            vertical: MahafezSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(120),
            borderRadius: BorderRadius.circular(99.responsiveRadius),
          ),
          child: Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
