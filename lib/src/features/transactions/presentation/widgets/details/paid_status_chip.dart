import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

class PaidStatusChip extends StatelessWidget {
  const PaidStatusChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: MahafezResponsive.symmetricPadding(
          horizontal: MahafezSpacing.lg,
          vertical: MahafezSpacing.sm,
        ),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [activeColor, activeColor.withAlpha(200)],
                )
              : null,
          color: isActive ? null : theme.colorScheme.surface,
          border: Border.all(
            color: isActive
                ? activeColor.withAlpha(100)
                : theme.colorScheme.outlineVariant.withAlpha(100),
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(24.responsiveRadius),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withAlpha(60),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isActive ? Colors.white : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}
