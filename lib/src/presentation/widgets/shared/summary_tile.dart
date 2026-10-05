import 'package:flutter/material.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../../domain/entities/wallet_entity.dart';
import '../../utils/localization_extension.dart';
import '../../utils/provider_ext.dart';
import 'provider_icon.dart';

class SummaryTile extends StatelessWidget {
  const SummaryTile({
    super.key,
    required this.wallet,
    this.ownerName,
    this.showOwnerName = false,
    this.onActionPressed,
    this.actionIcon,
    this.actionTooltip,
    this.isActionLoading = false,
    this.actionColor,
  });

  final WalletEntity wallet;
  final String? ownerName;
  final bool showOwnerName;
  final VoidCallback? onActionPressed;
  final IconData? actionIcon;
  final String? actionTooltip;
  final bool isActionLoading;
  final Color? actionColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.mahafezColors;
    final theme = Theme.of(context);
    final provider = wallet.provider;
    final resolvedOwnerName = ownerName?.trim().isNotEmpty == true
        ? ownerName!.trim()
        : context.l10n.workspaceUnknownMember;

    return Container(
      padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
      decoration: BoxDecoration(
        color: context.mahafezColors.cardBackground,
        borderRadius: BorderRadius.circular(MahafezSpacing.lg.responsiveRadius),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow,
            blurRadius: MahafezSpacing.md.responsiveRadius,
            offset: Offset(0, MahafezSpacing.xs.responsiveHeight),
          ),
        ],
      ),
      child: Row(
        children: [
          ProviderIcon(
            provider: provider,
            size: MahafezSpacing.xxl.responsiveRadius,
          ),
          MahafezSpacing.md.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.displayName(context),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  EgyptianPhoneNumber.formatForDisplay(wallet.phoneNumber),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (showOwnerName)
                  Text(
                    resolvedOwnerName,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
          if (onActionPressed != null && actionIcon != null || isActionLoading)
            IconButton(
              onPressed: isActionLoading ? null : onActionPressed,
              tooltip: actionTooltip,
              icon: isActionLoading
                  ? SizedBox.square(
                      dimension: MahafezSpacing.lg.responsiveWidth,
                      child: CircularProgressIndicator(
                        strokeWidth: MahafezSpacing.xxs.responsiveWidth,
                      ),
                    )
                  : Icon(
                      actionIcon,
                      color: actionColor ?? theme.colorScheme.error,
                    ),
            ),
        ],
      ),
    );
  }
}
