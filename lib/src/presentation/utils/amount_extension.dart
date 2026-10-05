import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../localization/wallet_localization.dart';

extension WalletAmountFormatting on num {
  String toLocalizedWalletAmount(BuildContext context, {int decimalDigits = 2}) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: decimalDigits,
    ).format(this);
  }

  String toWalletCurrencyText(
    BuildContext context, {
    int decimalDigits = 2,
    String? sign,
  }) {
    final buffer = StringBuffer();
    final normalizedSign = sign?.trim();

    if (normalizedSign != null && normalizedSign.isNotEmpty) {
      buffer.write('$normalizedSign ');
    }

    buffer
      ..write(toLocalizedWalletAmount(context, decimalDigits: decimalDigits))
      ..write(' ')
      ..write(context.walletL10n.currency);

    return buffer.toString();
  }
}
