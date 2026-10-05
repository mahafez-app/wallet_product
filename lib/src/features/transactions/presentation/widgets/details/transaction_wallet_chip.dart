import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/utils/provider_ext.dart';
import '../../../../../shared/widgets/provider_icon.dart';
import '../../../domain/entities/transaction_entity.dart';

class TransactionWalletChip extends StatelessWidget {
  const TransactionWalletChip({super.key, required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedPhone =
        EgyptianPhoneNumber.formatForDisplay(transaction.phoneNumber);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProviderIcon(
          provider: transaction.provider,
          size: MahafezSpacing.xl.responsiveRadius,
        ),
        MahafezSpacing.sm.horizontalSpace,
        Expanded(
          child: Text(
            '${transaction.provider.displayName(context)} · $formattedPhone',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
