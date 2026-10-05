import 'package:flutter/widgets.dart';

/// Pluggable localization resolver for Mahafez Wallet Product.
///
/// In the host app, this is configured during startup by setting
/// [MahafezWalletLocalization.resolver].
abstract final class MahafezWalletLocalization {
  static MahafezWalletStrings Function(BuildContext context)? resolver;

  static MahafezWalletStrings of(BuildContext context) {
    if (resolver != null) {
      return resolver!(context);
    }
    return const DefaultMahafezWalletStrings();
  }
}

extension MahafezWalletLocalizationExtension on BuildContext {
  MahafezWalletStrings get walletL10n => MahafezWalletLocalization.of(this);
}

/// Abstract strings contract required by Wallet Product presentation layer.
abstract interface class MahafezWalletStrings {
  String get addWalletTitle;
  String get addWalletDescription;
  String get addWalletAction;
  String get chooseProvider;
  String get phoneNumber;
  String get walletDetails;
  String get currentBalance;
  String get currency;
  String get lastActivity;
  String get totalIn;
  String get totalOut;
  String get walletBalanceEditAction;
  String get walletBalanceEditSuccess;
  String get walletResetStats;
  String get walletResetStatsDescription;
  String get walletResetStatsAction;
  String get commonCancelAction;
  String get walletStatusActive;
  String get workspaceUnknownMember;

  String providerName(String providerKey);
  String walletStatsFrom(String dateText);
}

/// Fallback strings if not explicitly overridden by shell.
final class DefaultMahafezWalletStrings implements MahafezWalletStrings {
  const DefaultMahafezWalletStrings();

  @override
  String get addWalletTitle => 'إضافة محفظة';
  @override
  String get addWalletDescription => 'اختر مقدم الخدمة ورقم الهاتف المرتبط بمحفظتك الإلكترونية';
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
  String get walletResetStatsDescription => 'سيتم تصفير إجمالي الوارد والصادر وتعيين نقطة بداية جديدة من الآن.';
  @override
  String get walletResetStatsAction => 'إعادة تعيين';
  @override
  String get commonCancelAction => 'إلغاء';
  @override
  String get walletStatusActive => 'نشطة';
  @override
  String get workspaceUnknownMember => 'عضو غير معروف';

  @override
  String providerName(String providerKey) {
    return switch (providerKey.toLowerCase()) {
      'vodafonecash' => 'فودافون كاش',
      'orangemoney' => 'أورنج كاش',
      'etisalatcash' => 'اتصالات كاش',
      'wepay' => 'وي باي',
      'instapay' => 'انستاباي',
      _ => 'أخرى',
    };
  }

  @override
  String walletStatsFrom(String dateText) => 'منذ $dateText';
}
