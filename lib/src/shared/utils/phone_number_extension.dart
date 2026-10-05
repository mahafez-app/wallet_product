import 'package:mahafez_core/mahafez_core.dart';

extension PhoneNumberFormatting on String {
  String get formattedEgyptianPhoneNumber =>
      EgyptianPhoneNumber.formatForDisplay(this);
}
