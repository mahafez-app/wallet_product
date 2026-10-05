import 'package:flutter/material.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../../localization/wallet_localization.dart';
import '../../utils/amount_extension.dart';
import '../../utils/wallet_provider_ext.dart';
import 'wallet_provider_info.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({
    super.key,
    required this.provider,
    required this.phoneNumber,
    required this.balance,
  });

  final WalletProvider provider;
  final String phoneNumber;
  final double balance;

  @override
  Widget build(BuildContext context) {
    final l10n = context.walletL10n;
    final theme = Theme.of(context);
    final colors = context.mahafezColors;

    return Container(
      width: 290.responsiveWidth,
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(24.responsiveRadius),
        border: BorderDirectional(
          start: BorderSide(
            color: provider.brandColor,
            width: 5.responsiveWidth,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: 18.responsiveRadius,
            offset: Offset(0, 8.responsiveHeight),
          ),
        ],
      ),
      child: Padding(
        padding: MahafezResponsive.allPadding(MahafezSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            WalletProviderInfo(provider: provider, phoneNumber: phoneNumber),
            MahafezSpacing.lg.verticalSpace,
            Text(
              l10n.currentBalance,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            MahafezSpacing.xs.verticalSpace,
            _WalletBalance(balance: balance),
          ],
        ),
      ),
    );
  }
}

class _WalletBalance extends StatelessWidget {
  const _WalletBalance({required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) {
    final l10n = context.walletL10n;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          balance.toLocalizedWalletAmount(context),
          style: theme.textTheme.titleLarge?.copyWith(
            color: primary,
            fontSize: 24.responsiveFont,
            fontWeight: FontWeight.w700,
          ),
        ),
        MahafezSpacing.xs.horizontalSpace,
        Padding(
          padding: MahafezResponsive.onlyPadding(bottom: 4),
          child: FittedBox(
            child: Text(
              l10n.currency,
              style: theme.textTheme.labelSmall?.copyWith(
                color: primary,
                fontSize: 12.responsiveFont,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
