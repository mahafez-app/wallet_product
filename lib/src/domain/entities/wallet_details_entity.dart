import 'package:equatable/equatable.dart';

import 'wallet_entity.dart';

final class WalletDetailsEntity extends Equatable {
  const WalletDetailsEntity({
    required this.wallet,
    this.latestActivityBalance,
  });

  final WalletEntity wallet;
  final double? latestActivityBalance;

  double get suggestedBalance => latestActivityBalance ?? wallet.currentBalance;

  @override
  List<Object?> get props => [wallet, latestActivityBalance];
}
