import 'package:flutter/material.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../../../shared/utils/amount_extension.dart';
import '../../../../shared/utils/localization_extension.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.balance,
    required this.sentAmount,
    required this.receivedAmount,
    this.lastActivityText,
    this.statsResetDateText,
    this.onReset,
  });

  final double balance;
  final double sentAmount;
  final double receivedAmount;
  final String? lastActivityText;
  final String? statsResetDateText;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.mahafezColors;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: MahafezResponsive.allPadding(MahafezSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.responsiveRadius),
        gradient: LinearGradient(
          begin: const Alignment(0.18, -0.18),
          end: const Alignment(0.82, 1.18),
          colors: [colors.statsGradientStart, colors.statsGradientEnd],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.currentBalance,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.statsOnGradient,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (onReset != null)
                Material(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(12.responsiveRadius),
                  child: InkWell(
                    onTap: onReset,
                    borderRadius: BorderRadius.circular(12.responsiveRadius),
                    child: Padding(
                      padding: MahafezResponsive.symmetricPadding(horizontal: 10, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.restart_alt_rounded,
                            size: 16.responsiveRadius,
                            color: colors.statsOnGradient,
                          ),
                          MahafezSpacing.xs.horizontalSpace,
                          Text(
                            l10n.walletResetStatsAction,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colors.statsOnGradient,
                              fontWeight: FontWeight.w900,
                              fontSize: 12.responsiveFont,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          MahafezSpacing.sm.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                balance.toLocalizedAmount(context),
                style: theme.textTheme.displaySmall?.copyWith(
                  color: colors.statsOnGradient,
                  fontSize: 36.responsiveFont,
                  fontWeight: FontWeight.w700,
                ),
              ),
              MahafezSpacing.xs.horizontalSpace,
              Padding(
                padding: MahafezResponsive.onlyPadding(bottom: 6),
                child: Text(
                  l10n.currency,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.statsOnGradient,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (lastActivityText != null) ...[
            MahafezSpacing.xs.verticalSpace,
            Text(
              '${l10n.lastActivity}: $lastActivityText',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colors.statsOnGradient.withAlpha(204),
              ),
            ),
          ],
          if (statsResetDateText != null) ...[
            MahafezSpacing.md.verticalSpace,
            Container(
              padding: MahafezResponsive.symmetricPadding(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(25),
                borderRadius: BorderRadius.circular(10.responsiveRadius),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 12.responsiveRadius,
                    color: colors.statsOnGradient.withAlpha(180),
                  ),
                  MahafezSpacing.xs.horizontalSpace,
                  Text(
                    l10n.statsFrom(statsResetDateText!),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.statsOnGradient.withAlpha(200),
                      fontWeight: FontWeight.w600,
                      fontSize: 10.responsiveFont,
                    ),
                  ),
                ],
              ),
            ),
          ],
          MahafezSpacing.lg.verticalSpace,
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  title: l10n.totalOut,
                  amount: '- ${sentAmount.abs().toLocalizedAmount(context)}',
                  amountColor: colors.statsSentColor,
                  icon: Icons.arrow_outward,
                  iconColor: colors.statsSentColor,
                ),
              ),
              MahafezSpacing.lg.horizontalSpace,
              Expanded(
                child: _StatBox(
                  title: l10n.totalIn,
                  amount: '+ ${receivedAmount.abs().toLocalizedAmount(context)}',
                  amountColor: colors.statsReceivedColor,
                  icon: Icons.arrow_downward,
                  iconColor: colors.statsReceivedColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.title,
    required this.amount,
    required this.amountColor,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String amount;
  final Color amountColor;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.mahafezColors;
    final theme = Theme.of(context);

    return Container(
      padding: MahafezResponsive.allPadding(MahafezSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(20.responsiveRadius),
        border: Border.all(color: Colors.white.withAlpha(30), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: MahafezResponsive.allPadding(2.responsiveRadius),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(40),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14.responsiveRadius, color: iconColor),
              ),
              MahafezSpacing.xs.horizontalSpace,
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colors.statsOnGradient.withAlpha(180),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          MahafezSpacing.sm.verticalSpace,
          FittedBox(
            child: Text(
              amount,
              style: theme.textTheme.titleMedium?.copyWith(
                color: amountColor,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
