import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String toFormattedDate(BuildContext context) {
    return DateFormat(
      'd MMMM yyyy · H:mm',
      Localizations.localeOf(context).toLanguageTag(),
    ).format(this);
  }

  String toTimeLabel(BuildContext context) => DateFormat.jm(
    Localizations.localeOf(context).toLanguageTag(),
  ).format(this);

  String toMonthDayLabel(BuildContext context) => DateFormat.MMMd(
    Localizations.localeOf(context).toLanguageTag(),
  ).format(this);

  String toLongDateLabel(BuildContext context) => DateFormat.yMMMMd(
    Localizations.localeOf(context).toLanguageTag(),
  ).format(this);

  String toLongDateWithWeekdayLabel(BuildContext context) =>
      DateFormat.yMMMMEEEEd(
        Localizations.localeOf(context).toLanguageTag(),
      ).format(this);

  String toTransactionDateTimeLabel(BuildContext context) =>
      '${toLongDateLabel(context)} · ${toTimeLabel(context)}';
}
