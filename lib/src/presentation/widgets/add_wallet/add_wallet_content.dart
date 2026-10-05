import 'package:flutter/material.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../../localization/wallet_localization.dart';
import '../../providers/add_wallet_state.dart';
import 'add_wallet_phone_number_section.dart';
import 'add_wallet_provider_grid.dart';

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
    final s = context.walletL10n;
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
                AddWalletPhoneNumberSection(
                  phoneNumber: state.phoneNumber,
                  onPhoneNumberChanged: onPhoneNumberChanged,
                ),
                MahafezSpacing.lg.verticalSpace,
                Text(s.chooseProvider, style: theme.textTheme.titleMedium),
                MahafezSpacing.md.verticalSpace,
                AddWalletProviderGrid(
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
