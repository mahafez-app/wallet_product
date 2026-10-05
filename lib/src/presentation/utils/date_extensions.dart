import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String toFormattedDate(BuildContext context) {
    return DateFormat(
      'd MMMM yyyy · H:mm',
      Localizations.localeOf(context).toLanguageTag(),
    ).format(this);
  }
}
