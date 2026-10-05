import 'package:mahafez_core/mahafez_core.dart';

import '../entities/wallet_entity.dart';

typedef WalletDeletionHook = Future<void> Function(String walletId);

abstract interface class WalletRepository {
  Future<Result<List<WalletEntity>>> getWallets();

  Stream<List<WalletEntity>> watchWallets();

  Future<Result<List<WalletEntity>>> getWalletsByIds(List<String> walletIds);

  Stream<List<WalletEntity>> watchWalletsByIds(List<String> walletIds);

  Future<Result<List<WalletEntity>>> getWalletsByOwnerAndProvider({
    required String ownerUid,
    required String provider,
  });

  Future<Result<void>> addWallets({
    required String phoneNumber,
    required List<String> providers,
    Map<String, double> initialBalances,
  });

  Future<Result<WalletEntity>> getWalletDetails(String walletId);

  Future<Result<void>> deleteWallet(String walletId);

  Future<Result<void>> resetWalletStats(String walletId);

  Future<Result<void>> updateWalletBalance({
    required String walletId,
    required double balance,
  });
}
