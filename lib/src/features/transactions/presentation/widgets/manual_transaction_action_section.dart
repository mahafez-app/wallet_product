import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

class ManualTransactionActionSection extends StatelessWidget {
  const ManualTransactionActionSection({
    super.key,
    required this.primaryLabel,
    required this.isLoading,
    required this.onPrimaryPressed,
    required this.cancelLabel,
    required this.onCancelPressed,
  });

  final String primaryLabel;
  final bool isLoading;
  final VoidCallback? onPrimaryPressed;
  final String cancelLabel;
  final VoidCallback? onCancelPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MahafezButton(
            label: cancelLabel,
            type: MahafezButtonType.secondary,
            onPressed: onCancelPressed,
          ),
        ),
        MahafezSpacing.md.horizontalSpace,
        Expanded(
          child: MahafezButton(
            label: primaryLabel,
            isLoading: isLoading,
            onPressed: onPrimaryPressed,
          ),
        ),
      ],
    );
  }
}
