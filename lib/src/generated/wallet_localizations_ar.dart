// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'wallet_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class WalletLocalizationsAr extends WalletLocalizations {
  WalletLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get addWalletTitle => 'إضافة محفظة';

  @override
  String get addWalletDescription =>
      'اختر مقدم الخدمة ورقم الهاتف المرتبط بمحفظتك الإلكترونية';

  @override
  String get addWalletAction => 'إضافة المحفظة';

  @override
  String get chooseProvider => 'اختر مزود الخدمة';

  @override
  String get phoneNumber => 'رقم الهاتف المحمول';

  @override
  String get walletDetails => 'تفاصيل المحفظة';

  @override
  String get currentBalance => 'الرصيد الحالي';

  @override
  String get currency => 'ج.م';

  @override
  String get lastActivity => 'آخر نشاط';

  @override
  String get totalIn => 'إجمالي الوارد';

  @override
  String get totalOut => 'إجمالي الصادر';

  @override
  String get walletBalanceEditAction => 'تعديل الرصيد يدوياً';

  @override
  String get walletBalanceEditSuccess => 'تم تعديل الرصيد بنجاح';

  @override
  String get walletResetStats => 'إعادة تعيين الإحصائيات';

  @override
  String get walletResetStatsDescription =>
      'سيتم تصفير إجمالي الوارد والصادر وتعيين نقطة بداية جديدة من الآن.';

  @override
  String get walletResetStatsAction => 'إعادة تعيين';

  @override
  String get commonCancelAction => 'إلغاء';

  @override
  String get walletStatusActive => 'نشطة';

  @override
  String get workspaceUnknownMember => 'عضو غير معروف';

  @override
  String get providerVodafone => 'فودافون كاش';

  @override
  String get providerOrange => 'أورنج كاش';

  @override
  String get providerEtisalat => 'اتصالات كاش';

  @override
  String get providerWePay => 'وي باي';

  @override
  String get providerInstapay => 'انستاباي';

  @override
  String get providerUnknown => 'أخرى';

  @override
  String statsFrom(String date) {
    return 'منذ $date';
  }

  @override
  String get invalidAmountError => 'يرجى إدخال مبلغ صحيح';

  @override
  String get saveBalanceAction => 'حفظ الرصيد';
}
