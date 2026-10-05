// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import 'package:wallet_product/src/shared/utils/date_extensions.dart';
import '../../../../domain/entities/transaction_entity.dart';
import '../../../widgets/transaction_card.dart';

/// Groups transactions by calendar day and renders date headers.
class TransactionsDateGroupedList extends StatelessWidget {
  const TransactionsDateGroupedList({
    super.key,
    required this.groupedTransactions,
    required this.onTap,
    this.showProviderInfo = true,
    required this.footer,
  });

  final Map<DateTime, List<TransactionEntity>> groupedTransactions;
  final void Function(TransactionEntity) onTap;
  final bool showProviderInfo;

  /// Widget rendered at the very bottom (load more button / indicator).
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    final days = groupedTransactions.keys.toList();

    return ListView.builder(
      padding: MahafezSpacing.pagePadding,
      itemCount: days.length + 1, // +1 for footer
      itemBuilder: (context, index) {
        if (index == days.length) return footer;
        final day = days[index];
        final dayTransactions = groupedTransactions[day]!;
        return _DayGroup(
          day: day,
          transactions: dayTransactions,
          onTap: onTap,
          showProviderInfo: showProviderInfo,
        );
      },
    );
  }
}

class _DayGroup extends StatelessWidget {
  const _DayGroup({
    super.key,
    required this.day,
    required this.transactions,
    required this.onTap,
    required this.showProviderInfo,
  });

  final DateTime day;
  final List<TransactionEntity> transactions;
  final void Function(TransactionEntity) onTap;
  final bool showProviderInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DayHeader(day: day),
        MahafezSpacing.sm.verticalSpace,
        ...transactions.map(
          (tx) => GestureDetector(
            onTap: () => onTap(tx),
            child: TransactionCard(
              transaction: tx,
              showProviderInfo: showProviderInfo,
            ),
          ),
        ),
        MahafezSpacing.md.verticalSpace,
      ],
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({super.key, required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = day.toGroupedDateLabel(context);
    return Row(
      children: [
        Container(
          margin: MahafezResponsive.symmetricPadding(
            vertical: MahafezSpacing.sm,
          ),
          padding: MahafezResponsive.symmetricPadding(
            horizontal: MahafezSpacing.md,
            vertical: MahafezSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(12.responsiveRadius),
            border: Border.all(
              color: theme.colorScheme.primary.withAlpha(40),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 12.responsiveRadius,
                color: theme.colorScheme.primary,
              ),
              MahafezSpacing.xs.horizontalSpace,
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          child: Divider(indent: 12, endIndent: 0, thickness: 0.5),
        ),
      ],
    );
  }
}
