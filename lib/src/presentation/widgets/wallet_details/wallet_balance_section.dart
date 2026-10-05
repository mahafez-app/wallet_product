import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../../domain/entities/wallet_details_entity.dart';
import '../../../localization/wallet_localization.dart';
import '../../providers/wallet_details_controller.dart';
import '../../providers/wallet_providers.dart';
import '../../utils/date_extensions.dart';
import 'edit_wallet_balance_bottom_sheet.dart';
import 'wallet_balance_card.dart';

class WalletBalanceSection extends ConsumerWidget {
  const WalletBalanceSection({
    super.key,
    required this.details,
    this.manualTransactionActionBuilder,
  });

  final WalletDetailsEntity details;
  final Widget Function(BuildContext context, String walletId)?
      manualTransactionActionBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.walletL10n;
    final wallet = details.wallet;
    final localizedLastUpdate = wallet.lastBalanceAt.toFormattedWalletDate(context);

    final currentUser = ref.watch(walletAuthProvider).currentUser;
    final isOwner = currentUser?.uid == wallet.ownerUid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WalletBalanceCard(
          balance: wallet.currentBalance,
          sentAmount: wallet.totalSent,
          receivedAmount: wallet.totalReceived,
          lastActivityText: localizedLastUpdate,
          statsResetDateText: wallet.statsResetAt?.toFormattedWalletDate(context),
          onReset: isOwner ? () => _handleReset(context, ref) : null,
        ),
        if (isOwner) ...[
          if (manualTransactionActionBuilder != null) ...[
            MahafezSpacing.sm.verticalSpace,
            manualTransactionActionBuilder!(context, wallet.id),
          ],
          MahafezSpacing.sm.verticalSpace,
          MahafezButton(
            label: l10n.walletBalanceEditAction,
            type: .secondary,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => EditWalletBalanceBottomSheet.show(
              context,
              walletId: wallet.id,
              currentBalance: wallet.currentBalance,
              suggestedBalance: details.suggestedBalance,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _handleReset(BuildContext context, WidgetRef ref) async {
    final l10n = context.walletL10n;
    final confirmed = await MahafezDialog.show<bool>(
      context,
      title: l10n.walletResetStats,
      message: l10n.walletResetStatsDescription,
      confirmLabel: l10n.walletResetStatsAction,
      cancelLabel: l10n.commonCancelAction,
      type: .warning,
      onConfirm: () => Navigator.pop(context, true),
    );

    if (confirmed == true) {
      await ref
          .read(walletDetailsControllerProvider(details.wallet.id).notifier)
          .resetStats();
    }
  }
}
