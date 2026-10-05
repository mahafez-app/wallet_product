import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import '../../navigation/transactions_route_data.dart';
import 'transaction_date_filter_row.dart';
import 'transaction_member_filter_row.dart';
import 'transaction_paid_status_filter_row.dart';
import 'transaction_search_filter.dart';
import 'transaction_type_filter_row.dart';
import 'transaction_wallet_filter_row.dart';

/// Inline filter bar shown above the transaction list (not inside the bottom sheet).
///
/// Renders the same rows as [TransactionsFilterBottomSheet] but without the
/// header/apply UI — the list itself acts as a live filter bar.
class TransactionsFilterBar extends StatelessWidget {
  const TransactionsFilterBar({super.key, required this.routeData});

  final TransactionsRouteData routeData;

  @override
  Widget build(BuildContext context) {
    final isWorkspace = routeData is MultiWalletTransactionsRouteData;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TransactionSearchFilter(routeData: routeData),
        TransactionTypeFilterRow(routeData: routeData),
        TransactionPaidStatusFilterRow(routeData: routeData),
        TransactionDateFilterRow(routeData: routeData),
        if (isWorkspace) ...[
          TransactionMemberFilterRow(
            routeData: routeData as MultiWalletTransactionsRouteData,
          ),
          TransactionWalletFilterRow(
            routeData: routeData as MultiWalletTransactionsRouteData,
          ),
        ],
        MahafezSpacing.xs.verticalSpace,
        Divider(
          height: 1.responsiveHeight,
          thickness: 0.5.responsiveHeight,
          color: Theme.of(context).colorScheme.outlineVariant.withAlpha(80),
        ),
      ],
    );
  }
}
