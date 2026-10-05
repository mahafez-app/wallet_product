import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wallet_product/src/features/transactions/presentation/widgets/no_transactions_card.dart';
import 'package:wallet_product/src/shared/utils/localization_extension.dart';
import '../../navigation/transactions_route_data.dart';
import '../../providers/transactions_controller.dart';

class TransactionsEmptyView extends ConsumerWidget {
  const TransactionsEmptyView({
    super.key,
    required this.routeData,
    required this.hasActiveFilter,
  });

  final TransactionsRouteData routeData;
  final bool hasActiveFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(
      transactionsControllerProvider(routeData).notifier,
    );
    final footer = hasActiveFilter
        ? SizedBox(
            width: double.infinity,
            child: MahafezButton(
              label: context.l10n.transactions_clearFilters,
              type: MahafezButtonType.secondary,
              icon: Icon(
                Icons.filter_alt_off_rounded,
                size: MahafezSpacing.lg.responsiveRadius,
              ),
              onPressed: controller.clearAllFilters,
            ),
          )
        : null;

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: MahafezSpacing.pagePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NoTransactionsCard(
                  title: hasActiveFilter
                      ? context.l10n.transactions_emptyWithFilterTitle
                      : context.l10n.transactions_emptyTitle,
                  description: hasActiveFilter
                      ? context.l10n.transactions_emptyWithFilterDescription
                      : _emptyDescription(context),
                  variant: NoTransactionsCardVariant.fullScreen,
                  footer: footer,
                ),
                if (!hasActiveFilter) ...[
                  MahafezSpacing.xl.verticalSpace,
                  const TransactionsEmptyHintCard(),
                ],
                MahafezSpacing.xxl.verticalSpace,
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _emptyDescription(BuildContext context) => switch (routeData) {
    WalletTransactionsRouteData() =>
      context.l10n.transactions_emptyWalletDescription,
    MultiWalletTransactionsRouteData() =>
      context.l10n.transactions_emptyMultiWalletDescription,
  };
}
