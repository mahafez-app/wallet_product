import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:wallet_product/src/shared/utils/localization_extension.dart';

enum NoTransactionsCardVariant { preview, fullScreen }

class NoTransactionsCard extends StatelessWidget {
  const NoTransactionsCard({
    super.key,
    required this.title,
    required this.description,
    this.variant = NoTransactionsCardVariant.preview,
    this.footer,
  });

  final String title;
  final String description;
  final NoTransactionsCardVariant variant;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final colors = context.mahafezColors;
    final theme = Theme.of(context);
    final isFullScreen = variant == NoTransactionsCardVariant.fullScreen;
    final iconSize = isFullScreen ? MahafezSpacing.xxxl : MahafezSpacing.xxl;
    final iconPadding = isFullScreen ? MahafezSpacing.xl : MahafezSpacing.lg;
    final titleStyle = isFullScreen
        ? theme.textTheme.headlineSmall
        : theme.textTheme.titleLarge;

    return Container(
      padding: MahafezResponsive.allPadding(MahafezSpacing.xxl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(32.responsiveRadius),
        border: Border.all(color: colors.cardBorder.withAlpha(50), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: colors.cardShadow.withAlpha(100),
            blurRadius: 20,
            offset: Offset(0, 10.responsiveHeight),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: MahafezResponsive.allPadding(iconPadding),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withAlpha(40),
                  theme.colorScheme.primary.withAlpha(5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.responsiveRadius),
              border: Border.all(
                color: theme.colorScheme.primary.withAlpha(30),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: (iconSize * 1.2).responsiveRadius,
              color: theme.colorScheme.primary,
            ),
          ),
          MahafezSpacing.lg.verticalSpace,
          Text(
            title,
            textAlign: TextAlign.center,
            style: titleStyle?.copyWith(fontWeight: FontWeight.w800),
          ),
          MahafezSpacing.sm.verticalSpace,
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (footer != null) ...[MahafezSpacing.xl.verticalSpace, footer!],
        ],
      ),
    );
  }
}

class TransactionsEmptyHintCard extends StatelessWidget {
  const TransactionsEmptyHintCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.mahafezColors;
    final theme = Theme.of(context);

    return Container(
      padding: MahafezResponsive.allPadding(MahafezSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.infoContainer, theme.colorScheme.surface],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(
          MahafezSpacing.xxl.responsiveRadius,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: MahafezResponsive.allPadding(MahafezSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: theme.colorScheme.onPrimary,
              size: 20.responsiveRadius,
            ),
          ),
          MahafezSpacing.md.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.transactions_emptyHintTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                MahafezSpacing.xs.verticalSpace,
                Text(
                  context.l10n.transactions_emptyHintDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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
