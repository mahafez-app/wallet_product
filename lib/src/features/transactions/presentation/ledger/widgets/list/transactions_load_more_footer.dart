import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wallet_product/src/shared/utils/localization_extension.dart';
import '../../navigation/transactions_route_data.dart';
import '../../providers/transactions_controller.dart';

class TransactionsLoadMoreFooter extends ConsumerWidget {
  const TransactionsLoadMoreFooter({super.key, required this.routeData});

  final TransactionsRouteData routeData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionsControllerProvider(routeData));
    final controller = ref.read(
      transactionsControllerProvider(routeData).notifier,
    );

    if (state.isLoadingMore) {
      return Padding(
        padding: MahafezResponsive.symmetricPadding(
          vertical: MahafezSpacing.xl,
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!state.hasMore) return MahafezSpacing.lg.verticalSpace;

    return Padding(
      padding: MahafezResponsive.symmetricPadding(
        vertical: MahafezSpacing.xl,
        horizontal: MahafezSpacing.lg,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => controller.loadMore(),
            borderRadius: BorderRadius.circular(20.responsiveRadius),
            child: Container(
              padding: MahafezResponsive.symmetricPadding(
                horizontal: MahafezSpacing.xl,
                vertical: MahafezSpacing.md,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(20.responsiveRadius),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withAlpha(60),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20.responsiveRadius,
                  ),
                  MahafezSpacing.sm.horizontalSpace,
                  Text(
                    context.l10n.transactions_loadMore,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          MahafezSpacing.lg.verticalSpace,
          Container(
            padding: MahafezResponsive.symmetricPadding(
              horizontal: MahafezSpacing.md,
              vertical: MahafezSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999.responsiveRadius),
            ),
            child: Text(
              context.l10n.transactions_viewingCountOfTotal(
                state.transactions.length,
                state.totalCount,
              ),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
