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

  /// No description provided for @errorManualTransactionMessageRequired.
  ///
  /// In ar, this message translates to:
  /// **'الصق نص الرسالة أولاً.'**
  String get errorManualTransactionMessageRequired;

  /// No description provided for @recentTransactions.
  ///
  /// In ar, this message translates to:
  /// **'آخر المعاملات'**
  String get recentTransactions;

  /// No description provided for @startupFallbackRetryAction.
  ///
  /// In ar, this message translates to:
  /// **'حاول مرة أخرى'**
  String get startupFallbackRetryAction;

  /// No description provided for @transactionTypeReceive.
  ///
  /// In ar, this message translates to:
  /// **'استلام'**
  String get transactionTypeReceive;

  /// No description provided for @transactionTypeSend.
  ///
  /// In ar, this message translates to:
  /// **'إرسال'**
  String get transactionTypeSend;

  /// No description provided for @viewAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get viewAll;

  /// No description provided for @walletManualTransactionAnalyzeAction.
  ///
  /// In ar, this message translates to:
  /// **'تحليل الرسالة'**
  String get walletManualTransactionAnalyzeAction;

  /// No description provided for @walletManualTransactionBalanceChip.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد بعد الرسالة: {amount}'**
  String walletManualTransactionBalanceChip(Object amount);

  /// No description provided for @walletManualTransactionConfirmAction.
  ///
  /// In ar, this message translates to:
  /// **'حفظ على هذه المحفظة'**
  String get walletManualTransactionConfirmAction;

  /// No description provided for @walletManualTransactionDescription.
  ///
  /// In ar, this message translates to:
  /// **'الصق رسالة العملية الأصلية هنا، وسنطبق عليها نفس منطق التحليل والمطابقة المستخدم في القراءة التلقائية للرسائل.'**
  String get walletManualTransactionDescription;

  /// No description provided for @walletManualTransactionExplicitMismatchDescription.
  ///
  /// In ar, this message translates to:
  /// **'الرسالة تذكر رقم محفظة واضح لا يطابق المحفظة التي فتحتها الآن.'**
  String get walletManualTransactionExplicitMismatchDescription;

  /// No description provided for @walletManualTransactionExplicitMismatchTitle.
  ///
  /// In ar, this message translates to:
  /// **'الرسالة تخص محفظة أخرى'**
  String get walletManualTransactionExplicitMismatchTitle;

  /// No description provided for @walletManualTransactionFieldHint.
  ///
  /// In ar, this message translates to:
  /// **'الصق الرسالة كاملة كما وصلتك'**
  String get walletManualTransactionFieldHint;

  /// No description provided for @walletManualTransactionFieldLabel.
  ///
  /// In ar, this message translates to:
  /// **'نص الرسالة'**
  String get walletManualTransactionFieldLabel;

  /// No description provided for @walletManualTransactionForceAction.
  ///
  /// In ar, this message translates to:
  /// **'حفظ رغم ذلك'**
  String get walletManualTransactionForceAction;

  /// No description provided for @walletManualTransactionInferredMismatchDescription.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد الحالي وقواعد المطابقة تشير إلى محفظة مختلفة. احفظ هنا فقط لو أنت متأكد أن العملية يجب أن تُسجل على المحفظة الحالية.'**
  String get walletManualTransactionInferredMismatchDescription;

  /// No description provided for @walletManualTransactionInferredMismatchTitle.
  ///
  /// In ar, this message translates to:
  /// **'محفظة أخرى تبدو أقرب'**
  String get walletManualTransactionInferredMismatchTitle;

  /// No description provided for @walletManualTransactionPasteAction.
  ///
  /// In ar, this message translates to:
  /// **'لصق من الحافظة'**
  String get walletManualTransactionPasteAction;

  /// No description provided for @walletManualTransactionPhoneChip.
  ///
  /// In ar, this message translates to:
  /// **'رقم المحفظة المذكور: {phoneNumber}'**
  String walletManualTransactionPhoneChip(Object phoneNumber);

  /// No description provided for @walletManualTransactionReviewDescription.
  ///
  /// In ar, this message translates to:
  /// **'تم تحليل الرسالة بنجاح، لكن لم نتمكن من تأكيد المحفظة بنسبة كاملة. راجع التفاصيل قبل المتابعة.'**
  String get walletManualTransactionReviewDescription;

  /// No description provided for @walletManualTransactionReviewTitle.
  ///
  /// In ar, this message translates to:
  /// **'راجع المعاملة قبل الحفظ'**
  String get walletManualTransactionReviewTitle;

  /// No description provided for @walletManualTransactionSaveAction.
  ///
  /// In ar, this message translates to:
  /// **'حفظ العملية'**
  String get walletManualTransactionSaveAction;

  /// No description provided for @walletManualTransactionSaved.
  ///
  /// In ar, this message translates to:
  /// **'تمت إضافة المعاملة بنجاح.'**
  String get walletManualTransactionSaved;

  /// No description provided for @walletManualTransactionSuggestedWalletLabel.
  ///
  /// In ar, this message translates to:
  /// **'المحفظة المقترحة'**
  String get walletManualTransactionSuggestedWalletLabel;

  /// No description provided for @walletManualTransactionTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة معاملة من SMS'**
  String get walletManualTransactionTitle;

  /// No description provided for @walletSyncTransactionsAction.
  ///
  /// In ar, this message translates to:
  /// **'مزامنة المعاملات'**
  String get walletSyncTransactionsAction;

  /// No description provided for @walletSyncTransactionsDescription.
  ///
  /// In ar, this message translates to:
  /// **'افحص رسائل الـ SMS الأخيرة للبحث عن معاملات وصلت بعد آخر نشاط محفوظ على هذه المحفظة.'**
  String get walletSyncTransactionsDescription;

  /// No description provided for @walletSyncTransactionsEmptyDescription.
  ///
  /// In ar, this message translates to:
  /// **'لم نجد أي معاملات SMS غير محفوظة لهذه المحفظة في سجل الرسائل الأخير.'**
  String get walletSyncTransactionsEmptyDescription;

  /// No description provided for @walletSyncTransactionsEmptySinceDescription.
  ///
  /// In ar, this message translates to:
  /// **'لم نجد أي معاملات SMS غير محفوظة بعد {date}.'**
  String walletSyncTransactionsEmptySinceDescription(String date);

  /// No description provided for @walletSyncTransactionsEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد معاملات فائتة'**
  String get walletSyncTransactionsEmptyTitle;

  /// No description provided for @walletSyncTransactionsFoundCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{لم نجد معاملات فائتة} =1{تم العثور على معاملة فائتة واحدة} other{تم العثور على {count} معاملات فائتة}}'**
  String walletSyncTransactionsFoundCount(int count);

  /// No description provided for @walletSyncTransactionsFromDate.
  ///
  /// In ar, this message translates to:
  /// **'نفحص الرسائل بعد {date}'**
  String walletSyncTransactionsFromDate(String date);

  /// No description provided for @walletSyncTransactionsReviewTitle.
  ///
  /// In ar, this message translates to:
  /// **'راجع المعاملات غير المحفوظة'**
  String get walletSyncTransactionsReviewTitle;

  /// No description provided for @walletSyncTransactionsSaveAction.
  ///
  /// In ar, this message translates to:
  /// **'إضافة المحدد'**
  String get walletSyncTransactionsSaveAction;

  /// No description provided for @walletSyncTransactionsSavedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{تمت إضافة معاملة واحدة بنجاح.} other{تمت إضافة {count} معاملات بنجاح.}}'**
  String walletSyncTransactionsSavedSuccess(int count);

  /// No description provided for @walletSyncTransactionsSelectedCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{لا توجد معاملات محددة} =1{معاملة واحدة محددة} other{{count} معاملات محددة}}'**
  String walletSyncTransactionsSelectedCount(int count);

  /// No description provided for @walletSyncTransactionsTitle.
  ///
  /// In ar, this message translates to:
  /// **'مزامنة المعاملات الفائتة'**
  String get walletSyncTransactionsTitle;

  /// No description provided for @walletLabel.
  ///
  /// In ar, this message translates to:
  /// **'محفظتك'**
  String get walletLabel;

  /// No description provided for @paymentStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة السداد'**
  String get paymentStatus;

  /// No description provided for @transactionStatusPaid.
  ///
  /// In ar, this message translates to:
  /// **'مدفوع'**
  String get transactionStatusPaid;

  /// No description provided for @transactionStatusUnpaid.
  ///
  /// In ar, this message translates to:
  /// **'غير مدفوع'**
  String get transactionStatusUnpaid;

  /// No description provided for @transaction_receivedFrom.
  ///
  /// In ar, this message translates to:
  /// **'تم الاستلام من'**
  String get transaction_receivedFrom;

  /// No description provided for @transaction_sentTo.
  ///
  /// In ar, this message translates to:
  /// **'تم الإرسال إلى'**
  String get transaction_sentTo;

  /// No description provided for @transactions_emptyWalletDescription.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد معاملات على هذه المحفظة حتى الآن. أول ما توصلك رسائل جديدة هتظهر هنا تلقائياً.'**
  String get transactions_emptyWalletDescription;
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
