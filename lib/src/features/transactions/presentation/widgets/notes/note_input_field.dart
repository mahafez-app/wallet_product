// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/utils/localization_extension.dart';

/// Reusable inline text-field used for both adding a new note and editing
/// an existing one. Pass [isBusy] to show a loading indicator in place of
/// the send button while the Firestore write is in flight.
class NoteInputField extends StatelessWidget {
  const NoteInputField({
    super.key,
    required this.controller,
    required this.isBusy,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool isBusy;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: _NoteTextField(controller: controller, onSubmit: onSubmit),
        ),
        MahafezSpacing.sm.horizontalSpace,
        _SubmitButton(isBusy: isBusy, onSubmit: onSubmit),
      ],
    );
  }
}

class _NoteTextField extends StatelessWidget {
  const _NoteTextField({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      minLines: 1,
      autofocus: true,
      decoration: InputDecoration(
        hintText: context.l10n.transaction_noteHint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.responsiveRadius),
        ),
        contentPadding: MahafezResponsive.symmetricPadding(
          horizontal: MahafezSpacing.md,
          vertical: MahafezSpacing.sm,
        ),
      ),
      onSubmitted: (_) => onSubmit(),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    super.key,
    required this.isBusy,
    required this.onSubmit,
  });

  final bool isBusy;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    if (isBusy) return const CircularProgressIndicator();
    return IconButton.filled(
      onPressed: onSubmit,
      icon: const Icon(Icons.send_rounded),
    );
  }
}
