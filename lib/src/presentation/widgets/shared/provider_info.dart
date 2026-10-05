import 'package:flutter/material.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../utils/localization_extension.dart';
import '../../utils/provider_ext.dart';
import 'provider_icon.dart';

class ProviderInfo extends StatelessWidget {
  const ProviderInfo({
    super.key,
    required this.provider,
    required this.phoneNumber,
    this.borderRadius = 20.0,
  });

  final WalletProvider provider;
  final String phoneNumber;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedPhone = EgyptianPhoneNumber.formatForDisplay(phoneNumber);

    return Row(
      children: [
        ProviderIcon(provider: provider, size: 40.responsiveRadius),
        MahafezSpacing.md.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Text(
                  provider.displayName(context).toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              MahafezSpacing.xs.verticalSpace,
              FittedBox(
                child: Text(
                  formattedPhone,
                  maxLines: 1,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        MahafezSpacing.md.horizontalSpace,
        _StatusBadge(provider: provider),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.provider});

  final WalletProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MahafezResponsive.symmetricPadding(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: provider.brandColor.withAlpha(30),
        borderRadius: BorderRadius.all(Radius.circular(8.responsiveRadius)),
        border: Border.all(
          color: provider.brandColor.withAlpha(60),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.responsiveRadius,
            height: 6.responsiveRadius,
            decoration: BoxDecoration(
              color: provider.brandColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: provider.brandColor.withAlpha(150),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          MahafezSpacing.xs.horizontalSpace,
          Text(
            context.l10n.walletStatusActive.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: provider.brandColor,
              fontWeight: FontWeight.w900,
              fontSize: 9.responsiveFont,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
