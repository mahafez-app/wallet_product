import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'localization_extension.dart';

extension AmountFormatting on num {
  String toLocalizedAmount(BuildContext context, {int decimalDigits = 2}) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: decimalDigits,
    ).format(this);
  }

  String toCurrencyText(
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
      ..write(toLocalizedAmount(context, decimalDigits: decimalDigits))
      ..write(' ')
      ..write(context.l10n.currency);

    return buffer.toString();
  }
}
