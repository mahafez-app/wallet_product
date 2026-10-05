import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

class TransactionInfoChip extends StatelessWidget {
  const TransactionInfoChip({
    super.key,
    required this.leading,
    required this.leadingBackgroundColor,
    required this.label,
    required this.value,
  });

  final Widget leading;
  final Color leadingBackgroundColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withAlpha(10),
        borderRadius: BorderRadius.circular(12.responsiveRadius),
      ),
      padding: MahafezResponsive.symmetricPadding(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 30.responsiveRadius,
            height: 30.responsiveRadius,
            decoration: BoxDecoration(
              color: leadingBackgroundColor,
              borderRadius: BorderRadius.circular(10.responsiveRadius),
            ),
            child: Center(child: leading),
          ),
          MahafezSpacing.md.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withAlpha(180),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                    fontSize: 12.responsiveFont,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
