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
}
