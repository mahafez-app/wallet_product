import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wallet_product/src/shared/utils/localization_extension.dart';
import '../../navigation/transactions_route_data.dart';
import '../../providers/draft_filters_controller.dart';
import '../../providers/transactions_state.dart';
import 'filter_row.dart';

class TransactionDateFilterRow extends ConsumerWidget {
  const TransactionDateFilterRow({super.key, required this.routeData});

  final TransactionsRouteData routeData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final datePreset = ref.watch(
      draftFiltersControllerProvider(routeData).select((s) => s.datePreset),
    );
    final controller = ref.read(
      draftFiltersControllerProvider(routeData).notifier,
    );

    return FilterRow(
      label: l10n.transactions_filterDate,
      chips: [
        FilterChipData(
          label: l10n.transactions_filter_all,
          isSelected: datePreset == DatePreset.none,
          onTap: () => controller.setDatePreset(DatePreset.none),
        ),
        FilterChipData(
          label: l10n.transactions_date_today,
          isSelected: datePreset == DatePreset.today,
          onTap: () => controller.setDatePreset(DatePreset.today),
        ),
        FilterChipData(
          label: l10n.transactions_date_yesterday,
          isSelected: datePreset == DatePreset.yesterday,
          onTap: () => controller.setDatePreset(DatePreset.yesterday),
        ),
        FilterChipData(
          label: l10n.transactions_date_week,
          isSelected: datePreset == DatePreset.week,
          onTap: () => controller.setDatePreset(DatePreset.week),
        ),
        FilterChipData(
          label: l10n.transactions_date_month,
          isSelected: datePreset == DatePreset.month,
          onTap: () => controller.setDatePreset(DatePreset.month),
        ),
        // Custom date range — tapping again clears it.
        FilterChipData(
          label: l10n.transactions_date_customRange,
          icon: Icons.date_range_rounded,
          isSelected: datePreset == DatePreset.custom,
          onTap: () => datePreset == DatePreset.custom
              ? controller.clearDatePreset()
              : _pickRange(context, controller),
        ),
      ],
    );
  }

  Future<void> _pickRange(
    BuildContext context,
    DraftFiltersController controller,
  ) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: now.subtract(const Duration(days: 7)),
        end: now,
      ),
    );
    if (range == null) return;
    controller.setDatePreset(DatePreset.custom, customRange: range);
  }
}
