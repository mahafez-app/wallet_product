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
}
