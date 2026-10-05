import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

extension WalletDateFormatting on DateTime {
  String toFormattedWalletDate(BuildContext context) {
    return DateFormat(
      'd MMMM yyyy · H:mm',
      Localizations.localeOf(context).toLanguageTag(),
    ).format(this);
  }
}
