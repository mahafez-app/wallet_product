import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import '../../../../shared/utils/localization_extension.dart';

class ManualTransactionInputSection extends StatelessWidget {
  const ManualTransactionInputSection({
    super.key,
    required this.messageController,
    required this.validator,
    required this.onChanged,
    required this.onPastePressed,
    this.isCompact = false,
  });

  final TextEditingController messageController;
  final String? Function(String?) validator;
  final ValueChanged<String> onChanged;
  final VoidCallback onPastePressed;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MahafezSpacing.sm.verticalSpace,
        Text(
          context.l10n.walletManualTransactionTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        if (!isCompact) ...[
          MahafezSpacing.sm.verticalSpace,
          Text(
            context.l10n.walletManualTransactionDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          MahafezSpacing.lg.verticalSpace,
        ] else
          MahafezSpacing.md.verticalSpace,
        MahafezTextField(
          label: context.l10n.walletManualTransactionFieldLabel,
          hintText: context.l10n.walletManualTransactionFieldHint,
          controller: messageController,
          keyboardType: TextInputType.multiline,
          minLines: isCompact ? 2 : 6,
          maxLines: isCompact ? 3 : 10,
          validator: validator,
          onChanged: onChanged,
        ),
        MahafezSpacing.sm.verticalSpace,
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: MahafezButton(
            label: context.l10n.walletManualTransactionPasteAction,
            type: MahafezButtonType.tertiary,
            icon: const Icon(Icons.content_paste_rounded),
            onPressed: onPastePressed,
          ),
        ),
      ],
    );
  }
}
