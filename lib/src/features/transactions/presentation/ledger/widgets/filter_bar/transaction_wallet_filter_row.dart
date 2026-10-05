import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wallet_product/src/shared/utils/localization_extension.dart';
import '../../navigation/transactions_route_data.dart';
import '../../providers/draft_filters_controller.dart';
import 'filter_row.dart';

class TransactionWalletFilterRow extends ConsumerWidget {
  const TransactionWalletFilterRow({super.key, required this.routeData});

  final MultiWalletTransactionsRouteData routeData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    // Only watch the fields that actually gate which wallets are visible.
    final useAllMembers = ref.watch(
      draftFiltersControllerProvider(routeData).select((s) => s.useAllMembers),
    );
    final selectedMemberUids = ref.watch(
      draftFiltersControllerProvider(
        routeData,
      ).select((s) => s.selectedMemberUids),
    );
    final useAllWallets = ref.watch(
      draftFiltersControllerProvider(routeData).select((s) => s.useAllWallets),
    );
    final selectedWalletIds = ref.watch(
      draftFiltersControllerProvider(
        routeData,
      ).select((s) => s.selectedWalletIds),
    );
    final controller = ref.read(
      draftFiltersControllerProvider(routeData).notifier,
    );

    final visibleWallets = useAllMembers
        ? routeData.wallets
        : routeData.wallets
              .where((w) => selectedMemberUids.contains(w.memberId))
              .toList();

    return FilterRow(
      label: l10n.transactions_filterWallet,
      chips: [
        FilterChipData(
          label: l10n.transactions_filter_all,
          isSelected: useAllWallets,
          onTap: () => controller.toggleWalletPreset(useAll: true),
        ),
        ...visibleWallets.map(
          (w) => FilterChipData(
            label: w.walletLabel,
            isSelected:
                !useAllWallets && selectedWalletIds.contains(w.walletId),
            onTap: () => controller.toggleWallet(w.walletId),
          ),
        ),
      ],
    );
  }
}
