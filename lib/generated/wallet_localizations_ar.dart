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

  @override
  String get errorManualTransactionMessageRequired => 'الصق نص الرسالة أولاً.';

  @override
  String get recentTransactions => 'آخر المعاملات';

  @override
  String get startupFallbackRetryAction => 'حاول مرة أخرى';

  @override
  String get transactionTypeReceive => 'استلام';

  @override
  String get transactionTypeSend => 'إرسال';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get walletManualTransactionAnalyzeAction => 'تحليل الرسالة';

  @override
  String walletManualTransactionBalanceChip(Object amount) {
    return 'الرصيد بعد الرسالة: $amount';
  }

  @override
  String get walletManualTransactionConfirmAction => 'حفظ على هذه المحفظة';

  @override
  String get walletManualTransactionDescription =>
      'الصق رسالة العملية الأصلية هنا، وسنطبق عليها نفس منطق التحليل والمطابقة المستخدم في القراءة التلقائية للرسائل.';

  @override
  String get walletManualTransactionExplicitMismatchDescription =>
      'الرسالة تذكر رقم محفظة واضح لا يطابق المحفظة التي فتحتها الآن.';

  @override
  String get walletManualTransactionExplicitMismatchTitle =>
      'الرسالة تخص محفظة أخرى';

  @override
  String get walletManualTransactionFieldHint => 'الصق الرسالة كاملة كما وصلتك';

  @override
  String get walletManualTransactionFieldLabel => 'نص الرسالة';

  @override
  String get walletManualTransactionForceAction => 'حفظ رغم ذلك';

  @override
  String get walletManualTransactionInferredMismatchDescription =>
      'الرصيد الحالي وقواعد المطابقة تشير إلى محفظة مختلفة. احفظ هنا فقط لو أنت متأكد أن العملية يجب أن تُسجل على المحفظة الحالية.';

  @override
  String get walletManualTransactionInferredMismatchTitle =>
      'محفظة أخرى تبدو أقرب';

  @override
  String get walletManualTransactionPasteAction => 'لصق من الحافظة';

  @override
  String walletManualTransactionPhoneChip(Object phoneNumber) {
    return 'رقم المحفظة المذكور: $phoneNumber';
  }

  @override
  String get walletManualTransactionReviewDescription =>
      'تم تحليل الرسالة بنجاح، لكن لم نتمكن من تأكيد المحفظة بنسبة كاملة. راجع التفاصيل قبل المتابعة.';

  @override
  String get walletManualTransactionReviewTitle => 'راجع المعاملة قبل الحفظ';

  @override
  String get walletManualTransactionSaveAction => 'حفظ العملية';

  @override
  String get walletManualTransactionSaved => 'تمت إضافة المعاملة بنجاح.';

  @override
  String get walletManualTransactionSuggestedWalletLabel => 'المحفظة المقترحة';

  @override
  String get walletManualTransactionTitle => 'إضافة معاملة من SMS';

  @override
  String get walletSyncTransactionsAction => 'مزامنة المعاملات';

  @override
  String get walletSyncTransactionsDescription =>
      'افحص رسائل الـ SMS الأخيرة للبحث عن معاملات وصلت بعد آخر نشاط محفوظ على هذه المحفظة.';

  @override
  String get walletSyncTransactionsEmptyDescription =>
      'لم نجد أي معاملات SMS غير محفوظة لهذه المحفظة في سجل الرسائل الأخير.';

  @override
  String walletSyncTransactionsEmptySinceDescription(String date) {
    return 'لم نجد أي معاملات SMS غير محفوظة بعد $date.';
  }

  @override
  String get walletSyncTransactionsEmptyTitle => 'لا توجد معاملات فائتة';

  @override
  String walletSyncTransactionsFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم العثور على $count معاملات فائتة',
      one: 'تم العثور على معاملة فائتة واحدة',
      zero: 'لم نجد معاملات فائتة',
    );
    return '$_temp0';
  }

  @override
  String walletSyncTransactionsFromDate(String date) {
    return 'نفحص الرسائل بعد $date';
  }

  @override
  String get walletSyncTransactionsReviewTitle => 'راجع المعاملات غير المحفوظة';

  @override
  String get walletSyncTransactionsSaveAction => 'إضافة المحدد';

  @override
  String walletSyncTransactionsSavedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تمت إضافة $count معاملات بنجاح.',
      one: 'تمت إضافة معاملة واحدة بنجاح.',
    );
    return '$_temp0';
  }

  @override
  String walletSyncTransactionsSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملات محددة',
      one: 'معاملة واحدة محددة',
      zero: 'لا توجد معاملات محددة',
    );
    return '$_temp0';
  }

  @override
  String get walletSyncTransactionsTitle => 'مزامنة المعاملات الفائتة';

  @override
  String get walletLabel => 'محفظتك';

  @override
  String get paymentStatus => 'حالة السداد';

  @override
  String get transactionStatusPaid => 'مدفوع';

  @override
  String get transactionStatusUnpaid => 'غير مدفوع';

  @override
  String get transaction_receivedFrom => 'تم الاستلام من';

  @override
  String get transaction_sentTo => 'تم الإرسال إلى';

  @override
  String get transactions_emptyWalletDescription =>
      'لا توجد معاملات على هذه المحفظة حتى الآن. أول ما توصلك رسائل جديدة هتظهر هنا تلقائياً.';
}
