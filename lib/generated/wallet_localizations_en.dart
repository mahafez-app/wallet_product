// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'wallet_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class WalletLocalizationsEn extends WalletLocalizations {
  WalletLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get addWalletTitle => 'Add Wallet';

  @override
  String get addWalletDescription =>
      'Select provider and enter the mobile number linked to your wallet';

  @override
  String get addWalletAction => 'Add Wallet';

  @override
  String get chooseProvider => 'Choose Provider';

  @override
  String get phoneNumber => 'Mobile Number';

  @override
  String get walletDetails => 'Wallet Details';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get currency => 'EGP';

  @override
  String get lastActivity => 'Last Activity';

  @override
  String get totalIn => 'Total In';

  @override
  String get totalOut => 'Total Out';

  @override
  String get walletBalanceEditAction => 'Edit Balance Manually';

  @override
  String get walletBalanceEditSuccess => 'Balance updated successfully';

  @override
  String get walletResetStats => 'Reset Statistics';

  @override
  String get walletResetStatsDescription =>
      'This will reset total sent and received amounts and set a new baseline.';

  @override
  String get walletResetStatsAction => 'Reset';

  @override
  String get commonCancelAction => 'Cancel';

  @override
  String get walletStatusActive => 'Active';

  @override
  String get workspaceUnknownMember => 'Unknown Member';

  @override
  String get providerVodafone => 'Vodafone Cash';

  @override
  String get providerOrange => 'Orange Money';

  @override
  String get providerEtisalat => 'Etisalat Cash';

  @override
  String get providerWePay => 'WE Pay';

  @override
  String get providerInstapay => 'InstaPay';

  @override
  String get providerUnknown => 'Other';

  @override
  String statsFrom(String date) {
    return 'Since $date';
  }

  @override
  String get invalidAmountError => 'Please enter a valid amount';

  @override
  String get saveBalanceAction => 'Save Balance';

  @override
  String get errorManualTransactionMessageRequired =>
      'Paste the SMS text first.';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get startupFallbackRetryAction => 'Try again';

  @override
  String get transactionTypeReceive => 'Receive';

  @override
  String get transactionTypeSend => 'Send';

  @override
  String get viewAll => 'View All';

  @override
  String get walletManualTransactionAnalyzeAction => 'Process SMS';

  @override
  String walletManualTransactionBalanceChip(Object amount) {
    return 'Balance after SMS: $amount';
  }

  @override
  String get walletManualTransactionConfirmAction => 'Save to this wallet';

  @override
  String get walletManualTransactionDescription =>
      'Paste the original transaction SMS here. We will parse it with the same wallet matching and transaction rules used by the automatic SMS flow.';

  @override
  String get walletManualTransactionExplicitMismatchDescription =>
      'The message explicitly mentions a wallet phone number that does not match the wallet you opened.';

  @override
  String get walletManualTransactionExplicitMismatchTitle =>
      'This SMS belongs to another wallet';

  @override
  String get walletManualTransactionFieldHint =>
      'Paste the full transaction message';

  @override
  String get walletManualTransactionFieldLabel => 'SMS text';

  @override
  String get walletManualTransactionForceAction => 'Save Anyway';

  @override
  String get walletManualTransactionInferredMismatchDescription =>
      'The balance and matching rules suggest a different wallet. Save here only if you are sure this SMS should stay under the current wallet.';

  @override
  String get walletManualTransactionInferredMismatchTitle =>
      'Another wallet looks more likely';

  @override
  String get walletManualTransactionPasteAction => 'Paste from clipboard';

  @override
  String walletManualTransactionPhoneChip(Object phoneNumber) {
    return 'Mentioned wallet: $phoneNumber';
  }

  @override
  String get walletManualTransactionReviewDescription =>
      'The SMS was parsed successfully, but the wallet could not be confirmed with full confidence. Review the details before continuing.';

  @override
  String get walletManualTransactionReviewTitle => 'Review before saving';

  @override
  String get walletManualTransactionSaveAction => 'Save Transaction';

  @override
  String get walletManualTransactionSaved => 'Transaction added successfully.';

  @override
  String get walletManualTransactionSuggestedWalletLabel => 'Suggested wallet';

  @override
  String get walletManualTransactionTitle => 'Add Transaction From SMS';

  @override
  String get walletSyncTransactionsAction => 'Sync transactions';

  @override
  String get walletSyncTransactionsDescription =>
      'Check recent SMS messages for transactions that arrived after your latest saved wallet activity.';

  @override
  String get walletSyncTransactionsEmptyDescription =>
      'We did not find any unsaved SMS transactions for this wallet in the recent inbox history.';

  @override
  String walletSyncTransactionsEmptySinceDescription(String date) {
    return 'We did not find any unsaved SMS transactions after $date.';
  }

  @override
  String get walletSyncTransactionsEmptyTitle =>
      'No missing transactions found';

  @override
  String walletSyncTransactionsFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count missing transactions found',
      one: '1 missing transaction found',
      zero: 'No missing transactions found',
    );
    return '$_temp0';
  }

  @override
  String walletSyncTransactionsFromDate(String date) {
    return 'Checking messages after $date';
  }

  @override
  String get walletSyncTransactionsReviewTitle => 'Review missing transactions';

  @override
  String get walletSyncTransactionsSaveAction => 'Add selected';

  @override
  String walletSyncTransactionsSavedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions added successfully.',
      one: '1 transaction added successfully.',
    );
    return '$_temp0';
  }

  @override
  String walletSyncTransactionsSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions selected',
      one: '1 transaction selected',
      zero: 'No transactions selected',
    );
    return '$_temp0';
  }

  @override
  String get walletSyncTransactionsTitle => 'Sync missed transactions';

  @override
  String get walletLabel => 'Your wallet';

  @override
  String get paymentStatus => 'Payment Status';

  @override
  String get transactionStatusPaid => 'Paid';

  @override
  String get transactionStatusUnpaid => 'Unpaid';

  @override
  String get transaction_receivedFrom => 'Received From';

  @override
  String get transaction_sentTo => 'Sent To';

  @override
  String get transactions_emptyWalletDescription =>
      'This wallet has no transactions yet. New messages will appear here automatically.';

  @override
  String get errorNetwork =>
      'No internet connection. Please check your network.';

  @override
  String get errorAuthUserNotFound =>
      'User not found. Please check your credentials.';

  @override
  String get errorAuthWrongPassword => 'Incorrect password. Please try again.';

  @override
  String get errorAuthEmailInUse => 'This email is already registered.';

  @override
  String get errorAuthTooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String get errorAuthUserDisabled => 'This account has been disabled.';

  @override
  String get errorAuthWeakPassword =>
      'Password is too weak. Please choose a stronger password.';

  @override
  String get errorAuthInvalidEmail => 'Invalid email address.';

  @override
  String get errorUnauthorized => 'Unauthorized access. Please log in again.';

  @override
  String get errorAuthGeneric => 'Authentication failed. Please try again.';

  @override
  String get errorForbidden => 'Access forbidden.';

  @override
  String get errorNotFound => 'Resource not found.';

  @override
  String get errorConflict => 'Resource conflict. Please try again.';

  @override
  String get errorUnprocessable => 'Unable to process your request.';

  @override
  String get errorServer => 'Server error. Please try again later.';

  @override
  String get errorServerGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorPermissionDenied => 'Permission denied.';

  @override
  String get errorCache => 'Local storage error. Please try again.';

  @override
  String get errorStorage => 'File storage error.';

  @override
  String get errorValidation => 'Validation failed.';

  @override
  String errorValidationWithCode(String code) {
    return 'Validation failed: $code';
  }

  @override
  String get errorUnknown => 'An unexpected error occurred.';

  @override
  String get errorWalletPhoneNumberRequired => 'Please enter a phone number';

  @override
  String get errorWalletPhoneNumberInvalid =>
      'Please enter a valid Egyptian mobile number.';

  @override
  String get errorWalletProviderRequired =>
      'Please select at least one provider';

  @override
  String get errorWalletProviderMismatch =>
      'This phone number only supports its matching mobile wallet provider and InstaPay.';

  @override
  String get errorWalletAlreadyExists => 'This wallet is already added.';

  @override
  String get errorWalletAllExists =>
      'All selected wallets are already added for this phone number.';

  @override
  String get errorManualTransactionUnrecognized =>
      'This text does not match the selected wallet\'s SMS format.';

  @override
  String get errorManualTransactionWalletMismatch =>
      'This SMS points to a different wallet than the one currently open.';

  @override
  String get errorWorkspaceNameRequired => 'Please enter a workspace name';

  @override
  String get errorWorkspaceWalletSelectionRequired =>
      'Please select at least one wallet';

  @override
  String get errorWorkspaceOwnerRemovalNotAllowed =>
      'The workspace owner cannot be removed.';

  @override
  String get errorWorkspaceMemberNotFound =>
      'This member is no longer available in the workspace.';

  @override
  String get errorInvitationSelfNotAllowed =>
      'You cannot invite yourself to this workspace.';

  @override
  String get errorInvitationAlreadyPending =>
      'A pending invitation already exists for this email.';

  @override
  String get errorInvitationUserNotFound =>
      'This email is not linked to any Mahafez account.';

  @override
  String get errorInvitationUserAlreadyMember =>
      'This user is already a member of the workspace.';

  @override
  String get errorInvitationNotPending =>
      'This invitation is no longer pending.';

  @override
  String get transaction_shareReceipt => 'Share Receipt';

  @override
  String transaction_receiptHeader(String type) {
    return 'Transaction Receipt — $type';
  }

  @override
  String get transaction_amount => 'Amount';

  @override
  String get transaction_wallet => 'Wallet';

  @override
  String get transaction_date => 'Date';

  @override
  String get transaction_dateTime => 'Date & Time';

  @override
  String get transaction_referenceNumber => 'Reference Number';

  @override
  String get transaction_history => 'Change History';

  @override
  String transaction_markedAs(String status) {
    return 'Marked as $status';
  }

  @override
  String transaction_by(String name) {
    return 'By $name';
  }

  @override
  String get transaction_notes => 'Notes';

  @override
  String get transaction_addNote => 'Add Note';

  @override
  String get transaction_noteHint => 'Write your note here…';

  @override
  String get transaction_deleteAction => 'Delete';

  @override
  String get transaction_deleteTitle => 'Delete Transaction';

  @override
  String get transaction_deleteMessage =>
      'Are you sure you want to delete this transaction? This action cannot be undone.';

  @override
  String get transaction_deletedSuccess => 'Transaction deleted';

  @override
  String get transaction_deleteNoteTitle => 'Delete Note';

  @override
  String get transaction_deleteNoteMessage =>
      'Are you sure you want to delete this note? This action cannot be undone.';

  @override
  String get transaction_noteDeleted => 'Note deleted';

  @override
  String get transaction_undo => 'Undo';

  @override
  String get transaction_edited => 'Edited';

  @override
  String get transaction_cancel => 'Cancel';

  @override
  String get transaction_save => 'Save';

  @override
  String get transaction_smsText => 'SMS Text';

  @override
  String get transaction_typeReceiveLabel => 'Receive Transaction';

  @override
  String get transaction_typeSendLabel => 'Send Transaction';

  @override
  String get transaction_errorGeneric => 'An error occurred';

  @override
  String get errorTransactionNotFound =>
      'This transaction is no longer available.';

  @override
  String get errorTransactionAlreadyExists =>
      'This transaction has already been tracked.';

  @override
  String get transactions_emptyTitle => 'No transactions yet';

  @override
  String get transactions_emptyHintTitle => 'Automatic tracking';

  @override
  String get transactions_emptyHintDescription =>
      'When activity is detected on a connected wallet, we sync it here for you automatically.';

  @override
  String get noTransactionsTitle =>
      'No transactions yet. New messages will appear here automatically.';

  @override
  String get allTransactions => 'All Transactions';

  @override
  String get viewAllTransactions => 'View All Transactions';

  @override
  String get transactionsHistory => 'Transaction History';

  @override
  String get transactionDetails => 'Transaction Details';

  @override
  String transactionMessageReceive(Object amount) {
    return 'Received $amount EGP';
  }

  @override
  String transactionMessageSend(Object amount) {
    return 'Sent $amount EGP';
  }

  @override
  String get transactions_filter_all => 'All';

  @override
  String get transactions_filter_allWallets => 'All Wallets';

  @override
  String get transactions_filter_allMembers => 'All Members';

  @override
  String get transactions_paymentStatusAll => 'All Statuses';

  @override
  String get transactions_searchHint => 'Search by last 2+ digits';

  @override
  String get transactions_date_today => 'Today';

  @override
  String get transactions_date_yesterday => 'Yesterday';

  @override
  String get transactions_date_week => 'This Week';

  @override
  String get transactions_date_month => 'This Month';

  @override
  String get transactions_date_customRange => 'Custom Range';

  @override
  String get transactions_loadMore => 'Load More';

  @override
  String transactions_viewingCountOfTotal(int count, int total) {
    return 'Viewing $count of $total transactions';
  }

  @override
  String get transactions_emptyWithFilter =>
      'No transactions match the selected filter';

  @override
  String get transactions_emptyWithFilterTitle => 'No matching transactions';

  @override
  String get transactions_emptyWithFilterDescription =>
      'Try clearing one or more filters to see more activity.';

  @override
  String get transactions_clearFilters => 'Clear Filters';

  @override
  String transactions_title_wallet(String name) {
    return 'Transactions: $name';
  }

  @override
  String get transactions_filterTitle => 'Filters';

  @override
  String get transactions_filterApply => 'Apply Filters';

  @override
  String get transactions_filterReset => 'Reset';

  @override
  String transactions_filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'filters',
      one: 'filter',
    );
    return '$count active $_temp0';
  }

  @override
  String get transactions_filterType => 'Type';

  @override
  String get transactions_filterPaidStatus => 'Status';

  @override
  String get transactions_filterDate => 'Date';

  @override
  String get transactions_filterMember => 'Member';

  @override
  String get transactions_filterWallet => 'Wallet';

  @override
  String get justNow => 'Just Now';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes mins ago';
  }

  @override
  String get transactions_emptyMultiWalletDescription =>
      'No transactions are available across these wallets yet.';
}
