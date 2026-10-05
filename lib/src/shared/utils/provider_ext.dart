import 'package:flutter/material.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import 'localization_extension.dart';

extension ProviderDisplay on WalletProvider {
  String displayName(BuildContext context) {
    return switch (this) {
      .vodafoneCash => context.l10n.providerVodafone,
      .orangeMoney => context.l10n.providerOrange,
      .etisalatCash => context.l10n.providerEtisalat,
      .instaPay => context.l10n.providerInstapay,
      .wePay => context.l10n.providerWePay,
      .unknown => context.l10n.providerUnknown,
    };
  }

  Color get brandColor => switch (this) {
    .vodafoneCash => MahafezColors.vodafoneRed,
    .orangeMoney => MahafezColors.orangeMoney,
    .etisalatCash => MahafezColors.etisalatGreen,
    .instaPay => MahafezColors.instaPayNavy,
    .wePay => MahafezColors.wePayPurple,
    .unknown => MahafezColors.providerUnknownNeutral,
  };
}
