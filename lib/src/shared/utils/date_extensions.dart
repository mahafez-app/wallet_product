import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'localization_extension.dart';

extension DateFormatting on DateTime {
  String toTimeAgo(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final difference = now.difference(this);
    final locale = Localizations.localeOf(context).toLanguageTag();

    if (difference.inMinutes < 1) return l10n.justNow;
    if (difference.inHours < 1) return l10n.minutesAgo(difference.inMinutes);
    if (_isToday(now)) return toTimeLabel(context);
    if (_isYesterday(now)) return l10n.transactions_date_yesterday;
    return DateFormat.yMMMd(locale).format(this);
  }

  String toGroupedDateLabel(BuildContext context) {
    final now = DateTime.now();
    if (_isToday(now)) return context.l10n.transactions_date_today;
    if (_isYesterday(now)) return context.l10n.transactions_date_yesterday;
    return toLongDateWithWeekdayLabel(context);
  }

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

  bool _isToday(DateTime reference) =>
      year == reference.year &&
      month == reference.month &&
      day == reference.day;

  bool _isYesterday(DateTime reference) {
    final yesterday = DateTime(
      reference.year,
      reference.month,
      reference.day,
    ).subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }
}
