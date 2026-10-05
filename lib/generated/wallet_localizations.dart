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

  /// No description provided for @errorNetwork.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد اتصال بالإنترنت. اتأكد من الشبكة وحاول مرة تانية.'**
  String get errorNetwork;

  /// No description provided for @errorAuthUserNotFound.
  ///
  /// In ar, this message translates to:
  /// **'الحساب غير موجود. اتأكد من بيانات الدخول.'**
  String get errorAuthUserNotFound;

  /// No description provided for @errorAuthWrongPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور غير صحيحة. حاول مرة تانية.'**
  String get errorAuthWrongPassword;

  /// No description provided for @errorAuthEmailInUse.
  ///
  /// In ar, this message translates to:
  /// **'هذا البريد الإلكتروني مسجل بالفعل.'**
  String get errorAuthEmailInUse;

  /// No description provided for @errorAuthTooManyRequests.
  ///
  /// In ar, this message translates to:
  /// **'عدد المحاولات كبير جداً. حاول مرة تانية بعد شوية.'**
  String get errorAuthTooManyRequests;

  /// No description provided for @errorAuthUserDisabled.
  ///
  /// In ar, this message translates to:
  /// **'تم تعطيل هذا الحساب.'**
  String get errorAuthUserDisabled;

  /// No description provided for @errorAuthWeakPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور ضعيفة. اختر كلمة مرور أقوى.'**
  String get errorAuthWeakPassword;

  /// No description provided for @errorAuthInvalidEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني غير صحيح.'**
  String get errorAuthInvalidEmail;

  /// No description provided for @errorUnauthorized.
  ///
  /// In ar, this message translates to:
  /// **'انتهت الجلسة. سجل دخولك مرة تانية.'**
  String get errorUnauthorized;

  /// No description provided for @errorAuthGeneric.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تسجيل الدخول الآن. حاول مرة تانية.'**
  String get errorAuthGeneric;

  /// No description provided for @errorForbidden.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكنك تنفيذ هذا الإجراء.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In ar, this message translates to:
  /// **'المطلوب غير موجود.'**
  String get errorNotFound;

  /// No description provided for @errorConflict.
  ///
  /// In ar, this message translates to:
  /// **'في تعارض في البيانات. حاول مرة تانية.'**
  String get errorConflict;

  /// No description provided for @errorUnprocessable.
  ///
  /// In ar, this message translates to:
  /// **'تعذر تنفيذ طلبك. راجع البيانات وحاول تاني.'**
  String get errorUnprocessable;

  /// No description provided for @errorServer.
  ///
  /// In ar, this message translates to:
  /// **'في مشكلة في الخدمة حالياً. حاول بعد شوية.'**
  String get errorServer;

  /// No description provided for @errorServerGeneric.
  ///
  /// In ar, this message translates to:
  /// **'حصلت مشكلة. حاول مرة تانية.'**
  String get errorServerGeneric;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In ar, this message translates to:
  /// **'الصلاحية غير متاحة.'**
  String get errorPermissionDenied;

  /// No description provided for @errorCache.
  ///
  /// In ar, this message translates to:
  /// **'حصلت مشكلة في حفظ البيانات على الجهاز. حاول مرة تانية.'**
  String get errorCache;

  /// No description provided for @errorStorage.
  ///
  /// In ar, this message translates to:
  /// **'حصلت مشكلة في حفظ الملف.'**
  String get errorStorage;

  /// No description provided for @errorValidation.
  ///
  /// In ar, this message translates to:
  /// **'راجع البيانات المدخلة.'**
  String get errorValidation;

  /// No description provided for @errorValidationWithCode.
  ///
  /// In ar, this message translates to:
  /// **'راجع البيانات المدخلة: {code}'**
  String errorValidationWithCode(String code);

  /// No description provided for @errorUnknown.
  ///
  /// In ar, this message translates to:
  /// **'حصلت مشكلة غير متوقعة.'**
  String get errorUnknown;

  /// No description provided for @errorWalletPhoneNumberRequired.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم الموبايل'**
  String get errorWalletPhoneNumberRequired;

  /// No description provided for @errorWalletPhoneNumberInvalid.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم موبايل مصري صحيح.'**
  String get errorWalletPhoneNumberInvalid;

  /// No description provided for @errorWalletProviderRequired.
  ///
  /// In ar, this message translates to:
  /// **'اختر شركة واحدة على الأقل'**
  String get errorWalletProviderRequired;

  /// No description provided for @errorWalletProviderMismatch.
  ///
  /// In ar, this message translates to:
  /// **'رقم الموبايل ده يدعم فقط شركة المحفظة المطابقة له وإنستاباي.'**
  String get errorWalletProviderMismatch;

  /// No description provided for @errorWalletAlreadyExists.
  ///
  /// In ar, this message translates to:
  /// **'هذه المحفظة مضافة بالفعل.'**
  String get errorWalletAlreadyExists;

  /// No description provided for @errorWalletAllExists.
  ///
  /// In ar, this message translates to:
  /// **'كل المحافظ المختارة مضافة بالفعل لهذا الرقم.'**
  String get errorWalletAllExists;

  /// No description provided for @errorManualTransactionUnrecognized.
  ///
  /// In ar, this message translates to:
  /// **'هذا النص لا يطابق صيغة رسائل هذه المحفظة.'**
  String get errorManualTransactionUnrecognized;

  /// No description provided for @errorManualTransactionWalletMismatch.
  ///
  /// In ar, this message translates to:
  /// **'الرسالة تشير إلى محفظة مختلفة عن المحفظة المفتوحة حالياً.'**
  String get errorManualTransactionWalletMismatch;

  /// No description provided for @errorWorkspaceNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم مساحة العمل'**
  String get errorWorkspaceNameRequired;

  /// No description provided for @errorWorkspaceWalletSelectionRequired.
  ///
  /// In ar, this message translates to:
  /// **'اختر محفظة واحدة على الأقل'**
  String get errorWorkspaceWalletSelectionRequired;

  /// No description provided for @errorWorkspaceOwnerRemovalNotAllowed.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن حذف مالك مساحة العمل.'**
  String get errorWorkspaceOwnerRemovalNotAllowed;

  /// No description provided for @errorWorkspaceMemberNotFound.
  ///
  /// In ar, this message translates to:
  /// **'العضو ده مش موجود في مساحة العمل حالياً.'**
  String get errorWorkspaceMemberNotFound;

  /// No description provided for @errorInvitationSelfNotAllowed.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكنك دعوة نفسك إلى مساحة العمل.'**
  String get errorInvitationSelfNotAllowed;

  /// No description provided for @errorInvitationAlreadyPending.
  ///
  /// In ar, this message translates to:
  /// **'في دعوة معلقة بالفعل لهذا البريد الإلكتروني.'**
  String get errorInvitationAlreadyPending;

  /// No description provided for @errorInvitationUserNotFound.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني ده غير مرتبط بحساب محافظ.'**
  String get errorInvitationUserNotFound;

  /// No description provided for @errorInvitationUserAlreadyMember.
  ///
  /// In ar, this message translates to:
  /// **'هذا المستخدم عضو بالفعل في مساحة العمل.'**
  String get errorInvitationUserAlreadyMember;

  /// No description provided for @errorInvitationNotPending.
  ///
  /// In ar, this message translates to:
  /// **'الدعوة دي لم تعد معلقة.'**
  String get errorInvitationNotPending;

  /// No description provided for @transaction_shareReceipt.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة إيصال العملية'**
  String get transaction_shareReceipt;

  /// No description provided for @transaction_receiptHeader.
  ///
  /// In ar, this message translates to:
  /// **'إيصال معاملة — {type}'**
  String transaction_receiptHeader(String type);

  /// No description provided for @transaction_amount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ'**
  String get transaction_amount;

  /// No description provided for @transaction_wallet.
  ///
  /// In ar, this message translates to:
  /// **'المحفظة'**
  String get transaction_wallet;

  /// No description provided for @transaction_date.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get transaction_date;

  /// No description provided for @transaction_dateTime.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ والوقت'**
  String get transaction_dateTime;

  /// No description provided for @transaction_referenceNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم العملية'**
  String get transaction_referenceNumber;

  /// No description provided for @transaction_history.
  ///
  /// In ar, this message translates to:
  /// **'سجل التعديلات'**
  String get transaction_history;

  /// No description provided for @transaction_markedAs.
  ///
  /// In ar, this message translates to:
  /// **'تم التحديد كـ {status}'**
  String transaction_markedAs(String status);

  /// No description provided for @transaction_by.
  ///
  /// In ar, this message translates to:
  /// **'بواسطة {name}'**
  String transaction_by(String name);

  /// No description provided for @transaction_notes.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات'**
  String get transaction_notes;

  /// No description provided for @transaction_addNote.
  ///
  /// In ar, this message translates to:
  /// **'إضافة ملاحظة'**
  String get transaction_addNote;

  /// No description provided for @transaction_noteHint.
  ///
  /// In ar, this message translates to:
  /// **'اكتب ملاحظتك هنا'**
  String get transaction_noteHint;

  /// No description provided for @transaction_deleteAction.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get transaction_deleteAction;

  /// No description provided for @transaction_deleteTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف المعاملة'**
  String get transaction_deleteTitle;

  /// No description provided for @transaction_deleteMessage.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد أنك تريد حذف هذه المعاملة؟ لا يمكن التراجع عن هذا الإجراء.'**
  String get transaction_deleteMessage;

  /// No description provided for @transaction_deletedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف المعاملة'**
  String get transaction_deletedSuccess;

  /// No description provided for @transaction_deleteNoteTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف الملاحظة'**
  String get transaction_deleteNoteTitle;

  /// No description provided for @transaction_deleteNoteMessage.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد أنك تريد حذف هذه الملاحظة؟ لا يمكن التراجع عن هذا الإجراء.'**
  String get transaction_deleteNoteMessage;

  /// No description provided for @transaction_noteDeleted.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف الملاحظة'**
  String get transaction_noteDeleted;

  /// No description provided for @transaction_undo.
  ///
  /// In ar, this message translates to:
  /// **'تراجع'**
  String get transaction_undo;

  /// No description provided for @transaction_edited.
  ///
  /// In ar, this message translates to:
  /// **'تم التعديل'**
  String get transaction_edited;

  /// No description provided for @transaction_cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get transaction_cancel;

  /// No description provided for @transaction_save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get transaction_save;

  /// No description provided for @transaction_smsText.
  ///
  /// In ar, this message translates to:
  /// **'نص الرسالة'**
  String get transaction_smsText;

  /// No description provided for @transaction_typeReceiveLabel.
  ///
  /// In ar, this message translates to:
  /// **'عملية استلام'**
  String get transaction_typeReceiveLabel;

  /// No description provided for @transaction_typeSendLabel.
  ///
  /// In ar, this message translates to:
  /// **'عملية إرسال'**
  String get transaction_typeSendLabel;

  /// No description provided for @transaction_errorGeneric.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ'**
  String get transaction_errorGeneric;

  /// No description provided for @errorTransactionNotFound.
  ///
  /// In ar, this message translates to:
  /// **'هذه المعاملة لم تعد متاحة.'**
  String get errorTransactionNotFound;

  /// No description provided for @errorTransactionAlreadyExists.
  ///
  /// In ar, this message translates to:
  /// **'هذه المعاملة مسجلة بالفعل.'**
  String get errorTransactionAlreadyExists;

  /// No description provided for @transactions_emptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد معاملات بعد'**
  String get transactions_emptyTitle;

  /// No description provided for @transactions_emptyHintTitle.
  ///
  /// In ar, this message translates to:
  /// **'متابعة تلقائية'**
  String get transactions_emptyHintTitle;

  /// No description provided for @transactions_emptyHintDescription.
  ///
  /// In ar, this message translates to:
  /// **'أول ما نرصد نشاط على محفظة مرتبطة، هنضيفه هنا تلقائياً.'**
  String get transactions_emptyHintDescription;

  /// No description provided for @noTransactionsTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد معاملات حتى الآن. أول ما توصلك رسائل جديدة هتظهر هنا.'**
  String get noTransactionsTitle;

  /// No description provided for @allTransactions.
  ///
  /// In ar, this message translates to:
  /// **'جميع المعاملات'**
  String get allTransactions;

  /// No description provided for @viewAllTransactions.
  ///
  /// In ar, this message translates to:
  /// **'عرض كل المعاملات'**
  String get viewAllTransactions;

  /// No description provided for @transactionsHistory.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ المعاملات'**
  String get transactionsHistory;

  /// No description provided for @transactionDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل المعاملة'**
  String get transactionDetails;

  /// No description provided for @transactionMessageReceive.
  ///
  /// In ar, this message translates to:
  /// **'تم استلام {amount} ج.م'**
  String transactionMessageReceive(Object amount);

  /// No description provided for @transactionMessageSend.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال {amount} ج.م'**
  String transactionMessageSend(Object amount);

  /// No description provided for @transactions_filter_all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get transactions_filter_all;

  /// No description provided for @transactions_filter_allWallets.
  ///
  /// In ar, this message translates to:
  /// **'كل المحافظ'**
  String get transactions_filter_allWallets;

  /// No description provided for @transactions_filter_allMembers.
  ///
  /// In ar, this message translates to:
  /// **'كل الأعضاء'**
  String get transactions_filter_allMembers;

  /// No description provided for @transactions_paymentStatusAll.
  ///
  /// In ar, this message translates to:
  /// **'كل الحالات'**
  String get transactions_paymentStatusAll;

  /// No description provided for @transactions_searchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث بآخر 2 أرقام أو أكثر'**
  String get transactions_searchHint;

  /// No description provided for @transactions_date_today.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get transactions_date_today;

  /// No description provided for @transactions_date_yesterday.
  ///
  /// In ar, this message translates to:
  /// **'أمس'**
  String get transactions_date_yesterday;

  /// No description provided for @transactions_date_week.
  ///
  /// In ar, this message translates to:
  /// **'الأسبوع'**
  String get transactions_date_week;

  /// No description provided for @transactions_date_month.
  ///
  /// In ar, this message translates to:
  /// **'الشهر'**
  String get transactions_date_month;

  /// No description provided for @transactions_date_customRange.
  ///
  /// In ar, this message translates to:
  /// **'نطاق مخصص'**
  String get transactions_date_customRange;

  /// No description provided for @transactions_loadMore.
  ///
  /// In ar, this message translates to:
  /// **'عرض المزيد'**
  String get transactions_loadMore;

  /// No description provided for @transactions_viewingCountOfTotal.
  ///
  /// In ar, this message translates to:
  /// **'عرض {count} من أصل {total} معاملة'**
  String transactions_viewingCountOfTotal(int count, int total);

  /// No description provided for @transactions_emptyWithFilter.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد معاملات مطابقة للفلاتر المحددة'**
  String get transactions_emptyWithFilter;

  /// No description provided for @transactions_emptyWithFilterTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد معاملات مطابقة'**
  String get transactions_emptyWithFilterTitle;

  /// No description provided for @transactions_emptyWithFilterDescription.
  ///
  /// In ar, this message translates to:
  /// **'جرّب مسح فلتر أو أكثر لعرض معاملات إضافية.'**
  String get transactions_emptyWithFilterDescription;

  /// No description provided for @transactions_clearFilters.
  ///
  /// In ar, this message translates to:
  /// **'مسح الفلاتر'**
  String get transactions_clearFilters;

  /// No description provided for @transactions_title_wallet.
  ///
  /// In ar, this message translates to:
  /// **'معاملات {name}'**
  String transactions_title_wallet(String name);

  /// No description provided for @transactions_filterTitle.
  ///
  /// In ar, this message translates to:
  /// **'الفلاتر'**
  String get transactions_filterTitle;

  /// No description provided for @transactions_filterApply.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق الفلاتر'**
  String get transactions_filterApply;

  /// No description provided for @transactions_filterReset.
  ///
  /// In ar, this message translates to:
  /// **'إعادة ضبط'**
  String get transactions_filterReset;

  /// No description provided for @transactions_filterActiveCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} فلتر {count, plural, =1{نشط} other{نشط}}'**
  String transactions_filterActiveCount(int count);

  /// No description provided for @transactions_filterType.
  ///
  /// In ar, this message translates to:
  /// **'النوع'**
  String get transactions_filterType;

  /// No description provided for @transactions_filterPaidStatus.
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get transactions_filterPaidStatus;

  /// No description provided for @transactions_filterDate.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get transactions_filterDate;

  /// No description provided for @transactions_filterMember.
  ///
  /// In ar, this message translates to:
  /// **'العضو'**
  String get transactions_filterMember;

  /// No description provided for @transactions_filterWallet.
  ///
  /// In ar, this message translates to:
  /// **'المحفظة'**
  String get transactions_filterWallet;

  /// No description provided for @justNow.
  ///
  /// In ar, this message translates to:
  /// **'الآن'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ {minutes} دقيقة'**
  String minutesAgo(Object minutes);

  /// No description provided for @transactions_emptyMultiWalletDescription.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد معاملات عبر هذه المحافظ حتى الآن.'**
  String get transactions_emptyMultiWalletDescription;
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
