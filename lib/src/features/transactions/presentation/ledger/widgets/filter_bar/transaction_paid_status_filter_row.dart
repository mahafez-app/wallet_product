import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wallet_product/src/shared/utils/localization_extension.dart';
import '../../navigation/transactions_route_data.dart';
import '../../providers/draft_filters_controller.dart';
import '../../providers/transactions_state.dart';
import '../../../../domain/entities/transaction_paid_status_filter.dart';
import 'filter_row.dart';

class TransactionPaidStatusFilterRow extends ConsumerWidget {
  const TransactionPaidStatusFilterRow({super.key, required this.routeData});

  final TransactionsRouteData routeData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    // Only watch the two fields we actually need — avoids full-state rebuilds.
    final typeFilter = ref.watch(
      draftFiltersControllerProvider(routeData).select((s) => s.typeFilter),
    );

    // Paid status is irrelevant for send-only; hide the row entirely.
    if (typeFilter == TransactionTypeFilter.send) {
      return const SizedBox.shrink();
    }

    final paidStatusFilter = ref.watch(
      draftFiltersControllerProvider(
        routeData,
      ).select((s) => s.paidStatusFilter),
    );
    final controller = ref.read(
      draftFiltersControllerProvider(routeData).notifier,
    );

    return FilterRow(
      label: l10n.transactions_filterPaidStatus,
      chips: [
        FilterChipData(
          label: l10n.transactions_filter_all,
          isSelected: paidStatusFilter == TransactionPaidStatusFilter.all,
          onTap: () =>
              controller.setPaidStatusFilter(TransactionPaidStatusFilter.all),
        ),
        FilterChipData(
          label: l10n.transactionStatusPaid,
          isSelected: paidStatusFilter == TransactionPaidStatusFilter.paid,
          onTap: () =>
              controller.setPaidStatusFilter(TransactionPaidStatusFilter.paid),
        ),
        FilterChipData(
          label: l10n.transactionStatusUnpaid,
          isSelected: paidStatusFilter == TransactionPaidStatusFilter.unpaid,
          onTap: () => controller.setPaidStatusFilter(
            TransactionPaidStatusFilter.unpaid,
          ),
        ),
      ],
    );
  }
}
