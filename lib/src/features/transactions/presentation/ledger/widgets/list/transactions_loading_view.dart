// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

class TransactionsLoadingView extends StatelessWidget {
  const TransactionsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: MahafezSpacing.pagePadding,
      children: const [
        _TransactionsDateGroupSkeleton(),
        _TransactionsDateGroupSkeleton(),
      ],
    );
  }
}

class _TransactionsDateGroupSkeleton extends StatelessWidget {
  const _TransactionsDateGroupSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MahafezSkeletonBox(
          width: 140.responsiveWidth,
          height: 18.responsiveHeight,
          borderRadius: BorderRadius.circular(999.responsiveRadius),
        ),
        MahafezSpacing.md.verticalSpace,
        const _TransactionsCardSkeleton(),
        MahafezSpacing.md.verticalSpace,
        const _TransactionsCardSkeleton(),
        MahafezSpacing.lg.verticalSpace,
      ],
    );
  }
}

class _TransactionsCardSkeleton extends StatelessWidget {
  const _TransactionsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24.responsiveRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MahafezSkeletonBox(
            width: 48.responsiveRadius,
            height: 48.responsiveRadius,
            borderRadius: BorderRadius.circular(16.responsiveRadius),
          ),
          MahafezSpacing.md.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MahafezSkeletonBox(
                      width: 100.responsiveWidth,
                      height: 16.responsiveHeight,
                    ),
                    const Spacer(),
                    MahafezSkeletonBox(
                      width: 80.responsiveWidth,
                      height: 20.responsiveHeight,
                    ),
                  ],
                ),
                MahafezSpacing.sm.verticalSpace,
                MahafezSkeletonBox(
                  width: 160.responsiveWidth,
                  height: 12.responsiveHeight,
                  borderRadius: BorderRadius.circular(999.responsiveRadius),
                ),
                MahafezSpacing.lg.verticalSpace,
                MahafezSkeletonBox(
                  width: double.infinity,
                  height: 36.responsiveHeight,
                  borderRadius: BorderRadius.circular(16.responsiveRadius),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
