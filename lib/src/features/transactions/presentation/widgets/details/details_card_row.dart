import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

class DetailsCardRow extends StatelessWidget {
  const DetailsCardRow({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: MahafezResponsive.symmetricPadding(
        horizontal: MahafezSpacing.lg,
        vertical: MahafezSpacing.md,
      ),
      child: Row(
        spacing: MahafezSpacing.lg,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(flex: 3, child: child),
        ],
      ),
    );
  }
}

class DetailsCardDivider extends StatelessWidget {
  const DetailsCardDivider({super.key});

  @override
  Widget build(BuildContext context) => Divider(
    height: 1,
    thickness: 0.5,
    indent: MahafezSpacing.lg.responsiveWidth,
    endIndent: MahafezSpacing.lg.responsiveWidth,
    color: Theme.of(context).colorScheme.outlineVariant.withAlpha(60),
  );
}
