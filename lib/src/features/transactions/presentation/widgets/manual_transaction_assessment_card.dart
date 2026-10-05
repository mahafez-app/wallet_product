import 'package:flutter/material.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../../../shared/utils/localization_extension.dart';
import '../../../../shared/widgets/provider_info.dart';
import '../../domain/entities/manual_transaction_assessment.dart';
import 'manual_transaction_summary_row.dart';

class ManualTransactionAssessmentCard extends StatelessWidget {
  const ManualTransactionAssessmentCard({
    super.key,
    required this.assessment,
  });

  final ManualTransactionAssessment assessment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = _resolveColors(colorScheme);

    return Container(
      width: double.infinity,
      padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(24.responsiveRadius),
        border: Border.all(color: colors.$2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: MahafezResponsive.allPadding(MahafezSpacing.sm),
                decoration: BoxDecoration(
                  color: colors.$2.withAlpha(26),
                  borderRadius: BorderRadius.circular(14.responsiveRadius),
                ),
                child: Icon(_icon, color: colors.$3, size: 22.responsiveRadius),
              ),
              MahafezSpacing.md.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title(context),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (assessment.requiresReview) ...[
                      MahafezSpacing.xs.verticalSpace,
                      Text(
                        _description(context),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          MahafezSpacing.md.verticalSpace,
          ManualTransactionSummaryRow(assessment: assessment),
          if (assessment.suggestedWallet != null) ...[
            MahafezSpacing.lg.verticalSpace,
            Text(
              context.l10n.walletManualTransactionSuggestedWalletLabel,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            MahafezSpacing.sm.verticalSpace,
            ProviderInfo(
              provider: assessment.suggestedWallet!.provider,
              phoneNumber: assessment.suggestedWallet!.phoneNumber,
              borderRadius: 12,
            ),
          ],
        ],
      ),
    );
  }

  (Color, Color, Color) _resolveColors(ColorScheme colorScheme) {
    return switch (assessment.reviewKind) {
      ManualTransactionReviewKind.explicitWalletMismatch => (
        colorScheme.errorContainer.withAlpha(120),
        colorScheme.error.withAlpha(80),
        colorScheme.error,
      ),
      ManualTransactionReviewKind.inferredWalletMismatch => (
        colorScheme.tertiaryContainer.withAlpha(120),
        colorScheme.tertiary.withAlpha(80),
        colorScheme.tertiary,
      ),
      ManualTransactionReviewKind.needsConfirmation => (
        colorScheme.primaryContainer.withAlpha(100),
        colorScheme.primary.withAlpha(70),
        colorScheme.primary,
      ),
      ManualTransactionReviewKind.none => (
        colorScheme.surfaceContainerHighest,
        colorScheme.outlineVariant,
        colorScheme.primary,
      ),
    };
  }

  IconData get _icon => switch (assessment.reviewKind) {
    ManualTransactionReviewKind.explicitWalletMismatch =>
      Icons.phone_locked_rounded,
    ManualTransactionReviewKind.inferredWalletMismatch =>
      Icons.balance_rounded,
    ManualTransactionReviewKind.needsConfirmation => Icons.rule_rounded,
    ManualTransactionReviewKind.none => Icons.check_circle_rounded,
  };

  String _title(BuildContext context) => switch (assessment.reviewKind) {
    ManualTransactionReviewKind.explicitWalletMismatch =>
      context.l10n.walletManualTransactionExplicitMismatchTitle,
    ManualTransactionReviewKind.inferredWalletMismatch =>
      context.l10n.walletManualTransactionInferredMismatchTitle,
    ManualTransactionReviewKind.needsConfirmation =>
      context.l10n.walletManualTransactionReviewTitle,
    ManualTransactionReviewKind.none =>
      context.l10n.walletManualTransactionReviewTitle,
  };

  String _description(BuildContext context) => switch (assessment.reviewKind) {
    ManualTransactionReviewKind.explicitWalletMismatch =>
      context.l10n.walletManualTransactionExplicitMismatchDescription,
    ManualTransactionReviewKind.inferredWalletMismatch =>
      context.l10n.walletManualTransactionInferredMismatchDescription,
    ManualTransactionReviewKind.needsConfirmation =>
      context.l10n.walletManualTransactionReviewDescription,
    ManualTransactionReviewKind.none =>
      context.l10n.walletManualTransactionReviewDescription,
  };
}
