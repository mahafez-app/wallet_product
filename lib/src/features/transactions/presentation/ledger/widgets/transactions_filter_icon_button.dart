import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallet_product/src/shared/utils/localization_extension.dart';
import '../navigation/transactions_route_data.dart';
import '../providers/transactions_controller.dart';
import 'filter_bar/transactions_filter_bottom_sheet.dart';

class TransactionsFilterIconButton extends ConsumerWidget {
  const TransactionsFilterIconButton({super.key, required this.routeData});

  final TransactionsRouteData routeData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCount = ref.watch(
      transactionsControllerProvider(
        routeData,
      ).select((s) => s.activeFilterCount),
    );

    return Padding(
      padding: MahafezResponsive.symmetricPadding(horizontal: 4),
      child: Badge(
        isLabelVisible: activeCount > 0,
        label: Text('$activeCount'),
        child: GestureDetector(
          child: Padding(
            padding: MahafezResponsive.symmetricPadding(
              horizontal: 4,
              vertical: 2,
            ),
            child: Icon(
              Icons.tune_rounded,
              semanticLabel: context.l10n.transactions_filterTitle,
            ),
          ),
          onTap: () => TransactionsFilterBottomSheet.show(context, routeData),
        ),
      ),
    );
  }
}
