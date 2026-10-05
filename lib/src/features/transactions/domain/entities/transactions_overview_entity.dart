import 'package:equatable/equatable.dart';
import 'package:mahafez_core/mahafez_core.dart';

class ActiveWalletEntity extends Equatable {
  const ActiveWalletEntity({
    required this.walletId,
    required this.provider,
    required this.phoneNumber,
    required this.lastActivityAt,
  });

  final String walletId;
  final WalletProvider provider;
  final String phoneNumber;
  final DateTime lastActivityAt;

  @override
  List<Object?> get props => [walletId, provider, phoneNumber, lastActivityAt];
}

class TransactionsOverviewEntity extends Equatable {
  const TransactionsOverviewEntity({
    required this.todayCollected,
    required this.todaySent,
    required this.unpaidCount,
    required this.latestActiveWallets,
  });

  final double todayCollected;
  final double todaySent;
  final int unpaidCount;
  final List<ActiveWalletEntity> latestActiveWallets;

  @override
  List<Object?> get props => [
    todayCollected,
    todaySent,
    unpaidCount,
    latestActiveWallets,
  ];
}
