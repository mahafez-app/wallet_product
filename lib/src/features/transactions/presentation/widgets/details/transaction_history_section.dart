// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/utils/date_extensions.dart';
import '../../../../../shared/utils/localization_extension.dart';
import '../../../domain/entities/transaction_history_entry_entity.dart';

/// Section 5: Timeline of paid/unpaid status changes.
class TransactionHistorySection extends StatelessWidget {
  const TransactionHistorySection({super.key, required this.entries});

  final List<TransactionHistoryEntryEntity> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(
          title: context.l10n.transaction_history,
          icon: Icons.history_rounded,
        ),
        MahafezSpacing.lg.verticalSpace,
        ...entries.asMap().entries.map(
          (entry) => _HistoryEntryTile(
            entry: entry.value,
            isFirst: entry.key == 0,
            isLast: entry.key == entries.length - 1,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 16.responsiveRadius,
          color: theme.colorScheme.primary,
        ),
        MahafezSpacing.sm.horizontalSpace,
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class _HistoryEntryTile extends StatelessWidget {
  const _HistoryEntryTile({
    super.key,
    required this.entry,
    required this.isFirst,
    required this.isLast,
  });

  final TransactionHistoryEntryEntity entry;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final dateText = entry.occurredAt.toMonthDayLabel(context);
    final timeText = entry.occurredAt.toTimeLabel(context);

    final color = isFirst
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant.withAlpha(150);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32.responsiveWidth,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!isLast)
                  Positioned(
                    top: 24.responsiveHeight,
                    bottom: 0,
                    child: Container(
                      width: 1.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.colorScheme.outlineVariant.withAlpha(100),
                            theme.colorScheme.outlineVariant.withAlpha(20),
                          ],
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 14.responsiveHeight,
                  child: Container(
                    width: 12.responsiveRadius,
                    height: 12.responsiveRadius,
                    decoration: BoxDecoration(
                      gradient: isFirst
                          ? LinearGradient(
                              colors: [color, color.withAlpha(150)],
                            )
                          : null,
                      color: isFirst ? null : color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 2,
                      ),
                      boxShadow: isFirst
                          ? [
                              BoxShadow(
                                color: color.withAlpha(60),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          MahafezSpacing.sm.horizontalSpace,
          Expanded(
            child: Padding(
              padding: MahafezResponsive.onlyPadding(bottom: MahafezSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    l10n.transaction_markedAs(
                      entry.isPaid
                          ? l10n.transactionStatusPaid
                          : l10n.transactionStatusUnpaid,
                    ).toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isFirst
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isFirst ? FontWeight.w900 : FontWeight.w700,
                      letterSpacing: 0.5,
                      fontSize: 11.responsiveFont,
                    ),
                  ),
                  MahafezSpacing.xs.verticalSpace,
                  Text(
                    '${l10n.transaction_by(entry.actorName)} · $dateText · $timeText',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withAlpha(180),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
