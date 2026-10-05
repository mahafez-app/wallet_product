import 'package:flutter/material.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../../../shared/utils/localization_extension.dart';
import '../../../wallets/domain/entities/wallet_entity.dart';
import 'transaction_sync_bottom_sheet.dart';

/// Transaction-sync section embedded inside DetailsScreen.
/// Shown only to the wallet owner.
/// [isOwner] must be provided by the host; defaults to true so callers that
/// don't have auth context still show the section.
class TransactionSyncSection extends StatelessWidget {
  const TransactionSyncSection({
    super.key,
    required this.wallet,
    this.isOwner = true,
  });

  final WalletEntity wallet;

  /// Whether the current user is the owner of this wallet.
  /// Pass `false` to hide the section for non-owners.
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    if (!isOwner) return const SizedBox.shrink();

    final colors = context.mahafezColors;
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadiusDirectional.circular(24.responsiveRadius),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.walletSyncTransactionsTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          MahafezSpacing.xs.verticalSpace,
          Text(
            l10n.walletSyncTransactionsDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          MahafezSpacing.md.verticalSpace,
          MahafezButton(
            label: l10n.walletSyncTransactionsAction,
            icon: const Icon(Icons.sync_rounded),
            onPressed: () => TransactionSyncBottomSheet.show(
              context,
              walletId: wallet.id,
            ),
          ),
        ],
      ),
    );
  }
}
