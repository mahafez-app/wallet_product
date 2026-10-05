import 'package:flutter/material.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../providers/add_wallet_state.dart';
import '../../utils/localization_extension.dart';
import 'phone_number_section.dart';
import 'provider_grid.dart';

class AddWalletContent extends StatelessWidget {
  const AddWalletContent({
    super.key,
    required this.state,
    required this.onPhoneNumberChanged,
    required this.onProviderToggled,
    required this.onSubmit,
  });

  final AddWalletState state;
  final ValueChanged<String> onPhoneNumberChanged;
  final ValueChanged<WalletProvider> onProviderToggled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: MahafezResponsive.allPadding(MahafezSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MahafezInfoCard(text: s.addWalletDescription),
                MahafezSpacing.lg.verticalSpace,
                PhoneNumberSection(
                  phoneNumber: state.phoneNumber,
                  onPhoneNumberChanged: onPhoneNumberChanged,
                ),
                MahafezSpacing.lg.verticalSpace,
                Text(s.chooseProvider, style: theme.textTheme.titleMedium),
                MahafezSpacing.md.verticalSpace,
                ProviderGrid(
                  selectedProviders: state.selectedProviders,
                  allowedProviders: state.allowedProviders,
                  onProviderToggled: onProviderToggled,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: MahafezResponsive.allPadding(MahafezSpacing.md),
          child: MahafezButton(
            label: s.addWalletAction,
            icon: const Icon(Icons.add_circle_outline),
            isLoading: state.isSubmitting,
            onPressed: onSubmit,
          ),
        ),
      ],
    );
  }
}
