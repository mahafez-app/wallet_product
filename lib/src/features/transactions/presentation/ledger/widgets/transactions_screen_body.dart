import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wallet_product/src/shared/utils/failure_extension.dart';
import '../navigation/transactions_route_data.dart';
import '../providers/transactions_controller.dart';
import 'list/transactions_date_grouped_list.dart';
import 'list/transactions_empty_view.dart';
import 'list/transactions_load_more_footer.dart';
import 'list/transactions_loading_view.dart';
import '../../widgets/details/transaction_details_bottom_sheet.dart';

class TransactionsScreenBody extends ConsumerWidget {
  const TransactionsScreenBody({super.key, required this.routeData});

  final TransactionsRouteData routeData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(transactionsControllerProvider(routeData), (previous, next) {
      final nextError = next.error;
      if (nextError == null || previous?.error == nextError) return;
      MahafezSnackbar.show(
        context,
        message: nextError.toLocalizedString(context),
        type: MahafezSnackbarType.error,
      );
    });

    return _TransactionsContent(routeData: routeData);
  }
}

class _TransactionsContent extends ConsumerWidget {
  const _TransactionsContent({required this.routeData});

  final TransactionsRouteData routeData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionsControllerProvider(routeData));

    if (state.isLoadingInitial) {
      return const TransactionsLoadingView();
    }

    if (state.error != null && state.transactions.isEmpty) {
      return MahafezErrorView(error: state.error!);
    }

    if (state.transactions.isEmpty) {
      return TransactionsEmptyView(
        routeData: routeData,
        hasActiveFilter: state.hasActiveFilter,
      );
    }

    final showProviderInfo = routeData is MultiWalletTransactionsRouteData;

    return TransactionsDateGroupedList(
      groupedTransactions: state.groupedTransactions,
      showProviderInfo: showProviderInfo,
      onTap: (tx) => TransactionDetailsBottomSheet.show(context, tx),
      footer: TransactionsLoadMoreFooter(routeData: routeData),
    );
  }
}
