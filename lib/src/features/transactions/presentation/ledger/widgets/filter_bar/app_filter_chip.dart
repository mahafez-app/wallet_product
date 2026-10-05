import 'package:flutter/material.dart';

/// A single selectable chip used in all filter rows.
///
/// Design decisions:
/// - Fixed height (36) — true pill shape, RTL-safe.
/// - Solid fill for both states — no ghost borders competing with fill.
/// - [onPrimary] text/icon on selected — correct contrast on solid primary.
/// - [AnimatedContainer] + [AnimatedDefaultTextStyle] for smooth transitions.
class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  // Single source of truth — FilterRow sizes its SizedBox to match.
  static const double height = 36;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: icon != null ? 10 : 14),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
              ),
              const SizedBox(width: 5),
            ],
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: (textTheme.labelMedium ?? const TextStyle()).copyWith(
                color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                height: 1, // kills line-height gap, keeps chip vertically tight
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
