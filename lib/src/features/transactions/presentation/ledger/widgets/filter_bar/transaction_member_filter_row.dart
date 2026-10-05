import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wallet_product/src/shared/utils/localization_extension.dart';
import '../../navigation/transactions_route_data.dart';
import '../../providers/draft_filters_controller.dart';
import 'filter_row.dart';

class TransactionMemberFilterRow extends ConsumerWidget {
  const TransactionMemberFilterRow({super.key, required this.routeData});

  final MultiWalletTransactionsRouteData routeData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final useAllMembers = ref.watch(
      draftFiltersControllerProvider(routeData).select((s) => s.useAllMembers),
    );
    final selectedMemberUids = ref.watch(
      draftFiltersControllerProvider(
        routeData,
      ).select((s) => s.selectedMemberUids),
    );
    final controller = ref.read(
      draftFiltersControllerProvider(routeData).notifier,
    );

    // Deduplicate by uid — same logic as before but computed once, not per build.
    final members = _uniqueMembers(routeData);

    return FilterRow(
      label: l10n.transactions_filterMember,
      chips: [
        FilterChipData(
          label: l10n.transactions_filter_all,
          isSelected: useAllMembers,
          onTap: controller.selectAllMembers,
        ),
        ...members.map(
          (m) => FilterChipData(
            label: m.label,
            isSelected: !useAllMembers && selectedMemberUids.contains(m.uid),
            onTap: () => controller.toggleMember(m.uid),
          ),
        ),
      ],
    );
  }

  static List<_MemberOption> _uniqueMembers(
    MultiWalletTransactionsRouteData routeData,
  ) {
    final seen = <String, _MemberOption>{};
    for (final wallet in routeData.wallets) {
      seen.putIfAbsent(
        wallet.memberId,
        () => _MemberOption(uid: wallet.memberId, label: wallet.memberName),
      );
    }
    return seen.values.toList();
  }
}

class _MemberOption {
  const _MemberOption({required this.uid, required this.label});
  final String uid;
  final String label;
}
