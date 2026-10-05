import 'package:equatable/equatable.dart';
import 'package:mahafez_core/mahafez_core.dart';

/// Wallet and member labels needed by multi-wallet transaction filters.
final class TransactionWalletFilterOption extends Equatable {
  const TransactionWalletFilterOption({
    required this.walletId,
    required this.walletLabel,
    required this.memberId,
    required this.memberName,
  });

  final String walletId;
  final String walletLabel;
  final String memberId;
  final String memberName;

  @override
  List<Object?> get props => [walletId, walletLabel, memberId, memberName];
}

/// Product screen configuration with the source and available filters.
sealed class TransactionsRouteData extends Equatable {
  const TransactionsRouteData();
}

final class WalletTransactionsRouteData extends TransactionsRouteData {
  const WalletTransactionsRouteData({
    required this.walletId,
    required this.provider,
    required this.phoneNumber,
  });

  final String walletId;
  final WalletProvider provider;
  final String phoneNumber;

  @override
  List<Object?> get props => [walletId, provider, phoneNumber];
}

final class MultiWalletTransactionsRouteData extends TransactionsRouteData {
  const MultiWalletTransactionsRouteData({
    required this.title,
    required this.wallets,
  });

  final String title;
  final List<TransactionWalletFilterOption> wallets;

  @override
  List<Object?> get props => [title, wallets];
}
