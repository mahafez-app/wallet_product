import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wallet_product/src/shared/utils/localization_extension.dart';
import '../../navigation/transactions_route_data.dart';
import '../../providers/draft_filters_controller.dart';
import '../../providers/transactions_state.dart';
import 'filter_row.dart';

class TransactionTypeFilterRow extends ConsumerWidget {
  const TransactionTypeFilterRow({super.key, required this.routeData});

  final TransactionsRouteData routeData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final typeFilter = ref.watch(
      draftFiltersControllerProvider(routeData).select((s) => s.typeFilter),
    );
    final controller = ref.read(
      draftFiltersControllerProvider(routeData).notifier,
    );

    return FilterRow(
      label: l10n.transactions_filterType,
      chips: [
        FilterChipData(
          label: l10n.transactions_filter_all,
          isSelected: typeFilter == TransactionTypeFilter.all,
          onTap: () => controller.setTypeFilter(TransactionTypeFilter.all),
        ),
        FilterChipData(
          label: l10n.transactionTypeReceive,
          isSelected: typeFilter == TransactionTypeFilter.receive,
          onTap: () => controller.setTypeFilter(TransactionTypeFilter.receive),
        ),
        FilterChipData(
          label: l10n.transactionTypeSend,
          isSelected: typeFilter == TransactionTypeFilter.send,
          onTap: () => controller.setTypeFilter(TransactionTypeFilter.send),
        ),
      ],
    );
  }
}
