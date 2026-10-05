import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wallet_product/src/shared/utils/localization_extension.dart';
import '../../navigation/transactions_route_data.dart';
import '../../providers/draft_filters_controller.dart';
import '../../providers/transactions_controller.dart';
import 'transaction_date_filter_row.dart';
import 'transaction_member_filter_row.dart';
import 'transaction_paid_status_filter_row.dart';
import 'transaction_search_filter.dart';
import 'transaction_type_filter_row.dart';
import 'transaction_wallet_filter_row.dart';

/// Modal bottom sheet containing all filter rows plus Apply / Reset controls.
///
/// Operates on a draft copy of filter state — changes are only committed when
/// the user taps "Apply Filters". Tapping "Reset" clears all filters and
/// closes immediately.
class TransactionsFilterBottomSheet extends ConsumerStatefulWidget {
  const TransactionsFilterBottomSheet({super.key, required this.routeData});

  final TransactionsRouteData routeData;

  static Future<void> show(
    BuildContext context,
    TransactionsRouteData routeData,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TransactionsFilterBottomSheet(routeData: routeData),
    );
  }

  @override
  ConsumerState<TransactionsFilterBottomSheet> createState() =>
      _TransactionsFilterBottomSheetState();
}

class _TransactionsFilterBottomSheetState
    extends ConsumerState<TransactionsFilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = context.l10n;
    final isWorkspace = widget.routeData is MultiWalletTransactionsRouteData;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(MahafezSpacing.xl.responsiveRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ────────────────────────────────────────────────────
          Padding(
            padding: MahafezResponsive.symmetricPadding(
              vertical: MahafezSpacing.md,
            ),
            child: Center(
              child: Container(
                width: 40.responsiveWidth,
                height: MahafezSpacing.xs.responsiveHeight,
                decoration: BoxDecoration(
                  color: colors.outlineVariant.withAlpha(120),
                  borderRadius: BorderRadius.circular(
                    MahafezSpacing.xs.responsiveRadius,
                  ),
                ),
              ),
            ),
          ),

          // ── Title + Reset ──────────────────────────────────────────────────
          Padding(
            padding: MahafezResponsive.horizontalPadding(MahafezSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.transactions_filterTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _reset,
                  child: Text(
                    l10n.transactions_filterReset,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 1.responsiveHeight,
            thickness: 0.5.responsiveHeight,
            color: colors.outlineVariant.withAlpha(80),
          ),

          // ── Scrollable filter rows ─────────────────────────────────────────
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                MahafezSpacing.xs.verticalSpace,
                TransactionSearchFilter(routeData: widget.routeData),
                TransactionTypeFilterRow(routeData: widget.routeData),
                TransactionPaidStatusFilterRow(routeData: widget.routeData),
                TransactionDateFilterRow(routeData: widget.routeData),
                if (isWorkspace) ...[
                  TransactionMemberFilterRow(
                    routeData:
                        widget.routeData as MultiWalletTransactionsRouteData,
                  ),
                  TransactionWalletFilterRow(
                    routeData:
                        widget.routeData as MultiWalletTransactionsRouteData,
                  ),
                ],
                MahafezSpacing.lg.verticalSpace,
              ],
            ),
          ),

          // ── Apply button ───────────────────────────────────────────────────
          Padding(
            padding: MahafezResponsive.onlyPadding(
              start: MahafezSpacing.lg,
              top: MahafezSpacing.md,
              end: MahafezSpacing.lg,
              bottom: MahafezSpacing.xxl,
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _apply,
                style: FilledButton.styleFrom(
                  padding: MahafezResponsive.symmetricPadding(
                    vertical: MahafezSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      MahafezSpacing.lg.responsiveRadius,
                    ),
                  ),
                ),
                child: Text(l10n.transactions_filterApply),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _apply() {
    final draft = ref.read(draftFiltersControllerProvider(widget.routeData));
    ref
        .read(transactionsControllerProvider(widget.routeData).notifier)
        .applyDraftFilters(draft);
    Navigator.of(context).pop();
  }

  void _reset() {
    ref
        .read(transactionsControllerProvider(widget.routeData).notifier)
        .clearAllFilters();
    Navigator.of(context).pop();
  }
}

// ── Filter badge ────────────────────────────────────────────────────────────

/// Wraps [child] with a [Badge] showing [count] when filters are active.
/// Returns [child] unwrapped when [count] is zero.
class FilterActiveBadge extends StatelessWidget {
  const FilterActiveBadge({
    super.key,
    required this.count,
    required this.child,
  });

  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return child;
    return Badge(label: Text('$count'), child: child);
  }
}
