import 'package:flutter/material.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../localization/wallet_localization.dart';

extension WalletProviderDisplay on WalletProvider {
  String displayName(BuildContext context) {
    return context.walletL10n.providerName(toValue);
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
