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

  @override
  String get errorNetwork =>
      'لا يوجد اتصال بالإنترنت. اتأكد من الشبكة وحاول مرة تانية.';

  @override
  String get errorAuthUserNotFound =>
      'الحساب غير موجود. اتأكد من بيانات الدخول.';

  @override
  String get errorAuthWrongPassword => 'كلمة المرور غير صحيحة. حاول مرة تانية.';

  @override
  String get errorAuthEmailInUse => 'هذا البريد الإلكتروني مسجل بالفعل.';

  @override
  String get errorAuthTooManyRequests =>
      'عدد المحاولات كبير جداً. حاول مرة تانية بعد شوية.';

  @override
  String get errorAuthUserDisabled => 'تم تعطيل هذا الحساب.';

  @override
  String get errorAuthWeakPassword => 'كلمة المرور ضعيفة. اختر كلمة مرور أقوى.';

  @override
  String get errorAuthInvalidEmail => 'البريد الإلكتروني غير صحيح.';

  @override
  String get errorUnauthorized => 'انتهت الجلسة. سجل دخولك مرة تانية.';

  @override
  String get errorAuthGeneric => 'تعذر تسجيل الدخول الآن. حاول مرة تانية.';

  @override
  String get errorForbidden => 'لا يمكنك تنفيذ هذا الإجراء.';

  @override
  String get errorNotFound => 'المطلوب غير موجود.';

  @override
  String get errorConflict => 'في تعارض في البيانات. حاول مرة تانية.';

  @override
  String get errorUnprocessable => 'تعذر تنفيذ طلبك. راجع البيانات وحاول تاني.';

  @override
  String get errorServer => 'في مشكلة في الخدمة حالياً. حاول بعد شوية.';

  @override
  String get errorServerGeneric => 'حصلت مشكلة. حاول مرة تانية.';

  @override
  String get errorPermissionDenied => 'الصلاحية غير متاحة.';

  @override
  String get errorCache =>
      'حصلت مشكلة في حفظ البيانات على الجهاز. حاول مرة تانية.';

  @override
  String get errorStorage => 'حصلت مشكلة في حفظ الملف.';

  @override
  String get errorValidation => 'راجع البيانات المدخلة.';

  @override
  String errorValidationWithCode(String code) {
    return 'راجع البيانات المدخلة: $code';
  }

  @override
  String get errorUnknown => 'حصلت مشكلة غير متوقعة.';

  @override
  String get errorWalletPhoneNumberRequired => 'أدخل رقم الموبايل';

  @override
  String get errorWalletPhoneNumberInvalid => 'أدخل رقم موبايل مصري صحيح.';

  @override
  String get errorWalletProviderRequired => 'اختر شركة واحدة على الأقل';

  @override
  String get errorWalletProviderMismatch =>
      'رقم الموبايل ده يدعم فقط شركة المحفظة المطابقة له وإنستاباي.';

  @override
  String get errorWalletAlreadyExists => 'هذه المحفظة مضافة بالفعل.';

  @override
  String get errorWalletAllExists =>
      'كل المحافظ المختارة مضافة بالفعل لهذا الرقم.';

  @override
  String get errorManualTransactionUnrecognized =>
      'هذا النص لا يطابق صيغة رسائل هذه المحفظة.';

  @override
  String get errorManualTransactionWalletMismatch =>
      'الرسالة تشير إلى محفظة مختلفة عن المحفظة المفتوحة حالياً.';

  @override
  String get errorWorkspaceNameRequired => 'أدخل اسم مساحة العمل';

  @override
  String get errorWorkspaceWalletSelectionRequired =>
      'اختر محفظة واحدة على الأقل';

  @override
  String get errorWorkspaceOwnerRemovalNotAllowed =>
      'لا يمكن حذف مالك مساحة العمل.';

  @override
  String get errorWorkspaceMemberNotFound =>
      'العضو ده مش موجود في مساحة العمل حالياً.';

  @override
  String get errorInvitationSelfNotAllowed =>
      'لا يمكنك دعوة نفسك إلى مساحة العمل.';

  @override
  String get errorInvitationAlreadyPending =>
      'في دعوة معلقة بالفعل لهذا البريد الإلكتروني.';

  @override
  String get errorInvitationUserNotFound =>
      'البريد الإلكتروني ده غير مرتبط بحساب محافظ.';

  @override
  String get errorInvitationUserAlreadyMember =>
      'هذا المستخدم عضو بالفعل في مساحة العمل.';

  @override
  String get errorInvitationNotPending => 'الدعوة دي لم تعد معلقة.';

  @override
  String get transaction_shareReceipt => 'مشاركة إيصال العملية';

  @override
  String transaction_receiptHeader(String type) {
    return 'إيصال معاملة — $type';
  }

  @override
  String get transaction_amount => 'المبلغ';

  @override
  String get transaction_wallet => 'المحفظة';

  @override
  String get transaction_date => 'التاريخ';

  @override
  String get transaction_dateTime => 'التاريخ والوقت';

  @override
  String get transaction_referenceNumber => 'رقم العملية';

  @override
  String get transaction_history => 'سجل التعديلات';

  @override
  String transaction_markedAs(String status) {
    return 'تم التحديد كـ $status';
  }

  @override
  String transaction_by(String name) {
    return 'بواسطة $name';
  }

  @override
  String get transaction_notes => 'ملاحظات';

  @override
  String get transaction_addNote => 'إضافة ملاحظة';

  @override
  String get transaction_noteHint => 'اكتب ملاحظتك هنا';

  @override
  String get transaction_deleteAction => 'حذف';

  @override
  String get transaction_deleteTitle => 'حذف المعاملة';

  @override
  String get transaction_deleteMessage =>
      'هل أنت متأكد أنك تريد حذف هذه المعاملة؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get transaction_deletedSuccess => 'تم حذف المعاملة';

  @override
  String get transaction_deleteNoteTitle => 'حذف الملاحظة';

  @override
  String get transaction_deleteNoteMessage =>
      'هل أنت متأكد أنك تريد حذف هذه الملاحظة؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get transaction_noteDeleted => 'تم حذف الملاحظة';

  @override
  String get transaction_undo => 'تراجع';

  @override
  String get transaction_edited => 'تم التعديل';

  @override
  String get transaction_cancel => 'إلغاء';

  @override
  String get transaction_save => 'حفظ';

  @override
  String get transaction_smsText => 'نص الرسالة';

  @override
  String get transaction_typeReceiveLabel => 'عملية استلام';

  @override
  String get transaction_typeSendLabel => 'عملية إرسال';

  @override
  String get transaction_errorGeneric => 'حدث خطأ';

  @override
  String get errorTransactionNotFound => 'هذه المعاملة لم تعد متاحة.';

  @override
  String get errorTransactionAlreadyExists => 'هذه المعاملة مسجلة بالفعل.';

  @override
  String get transactions_emptyTitle => 'لا توجد معاملات بعد';

  @override
  String get transactions_emptyHintTitle => 'متابعة تلقائية';

  @override
  String get transactions_emptyHintDescription =>
      'أول ما نرصد نشاط على محفظة مرتبطة، هنضيفه هنا تلقائياً.';

  @override
  String get noTransactionsTitle =>
      'لا توجد معاملات حتى الآن. أول ما توصلك رسائل جديدة هتظهر هنا.';

  @override
  String get allTransactions => 'جميع المعاملات';

  @override
  String get viewAllTransactions => 'عرض كل المعاملات';

  @override
  String get transactionsHistory => 'تاريخ المعاملات';

  @override
  String get transactionDetails => 'تفاصيل المعاملة';

  @override
  String transactionMessageReceive(Object amount) {
    return 'تم استلام $amount ج.م';
  }

  @override
  String transactionMessageSend(Object amount) {
    return 'تم إرسال $amount ج.م';
  }

  @override
  String get transactions_filter_all => 'الكل';

  @override
  String get transactions_filter_allWallets => 'كل المحافظ';

  @override
  String get transactions_filter_allMembers => 'كل الأعضاء';

  @override
  String get transactions_paymentStatusAll => 'كل الحالات';

  @override
  String get transactions_searchHint => 'ابحث بآخر 2 أرقام أو أكثر';

  @override
  String get transactions_date_today => 'اليوم';

  @override
  String get transactions_date_yesterday => 'أمس';

  @override
  String get transactions_date_week => 'الأسبوع';

  @override
  String get transactions_date_month => 'الشهر';

  @override
  String get transactions_date_customRange => 'نطاق مخصص';

  @override
  String get transactions_loadMore => 'عرض المزيد';

  @override
  String transactions_viewingCountOfTotal(int count, int total) {
    return 'عرض $count من أصل $total معاملة';
  }

  @override
  String get transactions_emptyWithFilter =>
      'لا توجد معاملات مطابقة للفلاتر المحددة';

  @override
  String get transactions_emptyWithFilterTitle => 'لا توجد معاملات مطابقة';

  @override
  String get transactions_emptyWithFilterDescription =>
      'جرّب مسح فلتر أو أكثر لعرض معاملات إضافية.';

  @override
  String get transactions_clearFilters => 'مسح الفلاتر';

  @override
  String transactions_title_wallet(String name) {
    return 'معاملات $name';
  }

  @override
  String get transactions_filterTitle => 'الفلاتر';

  @override
  String get transactions_filterApply => 'تطبيق الفلاتر';

  @override
  String get transactions_filterReset => 'إعادة ضبط';

  @override
  String transactions_filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'نشط',
      one: 'نشط',
    );
    return '$count فلتر $_temp0';
  }

  @override
  String get transactions_filterType => 'النوع';

  @override
  String get transactions_filterPaidStatus => 'الحالة';

  @override
  String get transactions_filterDate => 'التاريخ';

  @override
  String get transactions_filterMember => 'العضو';

  @override
  String get transactions_filterWallet => 'المحفظة';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object minutes) {
    return 'منذ $minutes دقيقة';
  }

  @override
  String get transactions_emptyMultiWalletDescription =>
      'لا توجد معاملات عبر هذه المحافظ حتى الآن.';

  @override
  String get reportPeriodToday => 'اليوم';

  @override
  String get reportPeriodYesterday => 'أمس';

  @override
  String get reportPeriodWeek => 'الأسبوع الماضي';

  @override
  String get reportPeriodMonth => 'الشهر الماضي';

  @override
  String get reportPeriodCustom => 'نطاق مخصص';

  @override
  String get reportAllWallets => 'كافة المحافظ';

  @override
  String get reportPerformance => 'الأداء المالي';

  @override
  String get reportBalance => 'صافي التدفق النقدي';

  @override
  String get reportTransactionCount => 'عدد المعاملات';

  @override
  String get reportDailyAverage => 'المتوسط اليومي';

  @override
  String get reportReceivedCount => 'المعاملات المستلمة';

  @override
  String get reportSentCount => 'المعاملات المرسلة';
}
