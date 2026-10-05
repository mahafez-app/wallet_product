import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../../localization/wallet_localization.dart';

class AddWalletPhoneNumberSection extends StatefulWidget {
  const AddWalletPhoneNumberSection({
    super.key,
    required this.phoneNumber,
    required this.onPhoneNumberChanged,
  });

  final String phoneNumber;
  final ValueChanged<String> onPhoneNumberChanged;

  @override
  State<AddWalletPhoneNumberSection> createState() =>
      _AddWalletPhoneNumberSectionState();
}

class _AddWalletPhoneNumberSectionState
    extends State<AddWalletPhoneNumberSection> {
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.phoneNumber);
  }

  @override
  void didUpdateWidget(covariant AddWalletPhoneNumberSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.phoneNumber != _phoneController.text) {
      _phoneController.value = TextEditingValue(
        text: widget.phoneNumber,
        selection: TextSelection.collapsed(offset: widget.phoneNumber.length),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.walletL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MahafezTextField(
          label: s.phoneNumber,
          hintText: s.phoneNumber,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          onChanged: widget.onPhoneNumberChanged,
        ),
        MahafezSpacing.xs.verticalSpace,
      ],
    );
  }
}
