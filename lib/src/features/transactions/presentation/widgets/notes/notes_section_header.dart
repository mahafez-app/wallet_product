import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/utils/localization_extension.dart';

/// Header row with a "Notes" title and an "Add" button.
class NotesSectionHeader extends StatelessWidget {
  const NotesSectionHeader({super.key, required this.onAddTap});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Icons.sticky_note_2_rounded,
          size: 16.responsiveRadius,
          color: theme.colorScheme.primary,
        ),
        MahafezSpacing.sm.horizontalSpace,
        Text(
          l10n.transaction_notes,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onAddTap,
          child: Container(
            padding: MahafezResponsive.symmetricPadding(
              horizontal: MahafezSpacing.md,
              vertical: MahafezSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(12.responsiveRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_rounded,
                  size: 14.responsiveRadius,
                  color: theme.colorScheme.primary,
                ),
                MahafezSpacing.xs.horizontalSpace,
                Text(
                  l10n.transaction_addNote,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
