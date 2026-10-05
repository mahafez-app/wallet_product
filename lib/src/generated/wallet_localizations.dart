import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'wallet_localizations_ar.dart';
import 'wallet_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of WalletLocalizations
/// returned by `WalletLocalizations.of(context)`.
///
/// Applications need to include `WalletLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/wallet_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: WalletLocalizations.localizationsDelegates,
///   supportedLocales: WalletLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the WalletLocalizations.supportedLocales
/// property.
abstract class WalletLocalizations {
  WalletLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static WalletLocalizations? of(BuildContext context) {
    return Localizations.of<WalletLocalizations>(context, WalletLocalizations);
  }

  static const LocalizationsDelegate<WalletLocalizations> delegate =
      _WalletLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @addWalletTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة محفظة'**
  String get addWalletTitle;

  /// No description provided for @addWalletDescription.
  ///
  /// In ar, this message translates to:
  /// **'اختر مقدم الخدمة ورقم الهاتف المرتبط بمحفظتك الإلكترونية'**
  String get addWalletDescription;

  /// No description provided for @addWalletAction.
  ///
  /// In ar, this message translates to:
  /// **'إضافة المحفظة'**
  String get addWalletAction;

  /// No description provided for @chooseProvider.
  ///
  /// In ar, this message translates to:
  /// **'اختر مزود الخدمة'**
  String get chooseProvider;

  /// No description provided for @phoneNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف المحمول'**
  String get phoneNumber;

  /// No description provided for @walletDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المحفظة'**
  String get walletDetails;

  /// No description provided for @currentBalance.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد الحالي'**
  String get currentBalance;

  /// No description provided for @currency.
  ///
  /// In ar, this message translates to:
  /// **'ج.م'**
  String get currency;

  /// No description provided for @lastActivity.
  ///
  /// In ar, this message translates to:
  /// **'آخر نشاط'**
  String get lastActivity;

  /// No description provided for @totalIn.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الوارد'**
  String get totalIn;

  /// No description provided for @totalOut.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الصادر'**
  String get totalOut;

  /// No description provided for @walletBalanceEditAction.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الرصيد يدوياً'**
  String get walletBalanceEditAction;

  /// No description provided for @walletBalanceEditSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تعديل الرصيد بنجاح'**
  String get walletBalanceEditSuccess;

  /// No description provided for @walletResetStats.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين الإحصائيات'**
  String get walletResetStats;

  /// No description provided for @walletResetStatsDescription.
  ///
  /// In ar, this message translates to:
  /// **'سيتم تصفير إجمالي الوارد والصادر وتعيين نقطة بداية جديدة من الآن.'**
  String get walletResetStatsDescription;

  /// No description provided for @walletResetStatsAction.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تعيين'**
  String get walletResetStatsAction;

  /// No description provided for @commonCancelAction.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get commonCancelAction;

  /// No description provided for @walletStatusActive.
  ///
  /// In ar, this message translates to:
  /// **'نشطة'**
  String get walletStatusActive;

  /// No description provided for @workspaceUnknownMember.
  ///
  /// In ar, this message translates to:
  /// **'عضو غير معروف'**
  String get workspaceUnknownMember;

  /// No description provided for @providerVodafone.
  ///
  /// In ar, this message translates to:
  /// **'فودافون كاش'**
  String get providerVodafone;

  /// No description provided for @providerOrange.
  ///
  /// In ar, this message translates to:
  /// **'أورنج كاش'**
  String get providerOrange;

  /// No description provided for @providerEtisalat.
  ///
  /// In ar, this message translates to:
  /// **'اتصالات كاش'**
  String get providerEtisalat;

  /// No description provided for @providerWePay.
  ///
  /// In ar, this message translates to:
  /// **'وي باي'**
  String get providerWePay;

  /// No description provided for @providerInstapay.
  ///
  /// In ar, this message translates to:
  /// **'انستاباي'**
  String get providerInstapay;

  /// No description provided for @providerUnknown.
  ///
  /// In ar, this message translates to:
  /// **'أخرى'**
  String get providerUnknown;

  /// No description provided for @statsFrom.
  ///
  /// In ar, this message translates to:
  /// **'منذ {date}'**
  String statsFrom(String date);

  /// No description provided for @invalidAmountError.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال مبلغ صحيح'**
  String get invalidAmountError;

  /// No description provided for @saveBalanceAction.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الرصيد'**
  String get saveBalanceAction;
}

class _WalletLocalizationsDelegate
    extends LocalizationsDelegate<WalletLocalizations> {
  const _WalletLocalizationsDelegate();

  @override
  Future<WalletLocalizations> load(Locale locale) {
    return SynchronousFuture<WalletLocalizations>(
      lookupWalletLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_WalletLocalizationsDelegate old) => false;
}

WalletLocalizations lookupWalletLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return WalletLocalizationsAr();
    case 'en':
      return WalletLocalizationsEn();
  }

  throw FlutterError(
    'WalletLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
