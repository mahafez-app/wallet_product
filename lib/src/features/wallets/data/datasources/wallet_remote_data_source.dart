import '../models/wallet_dto.dart';

abstract interface class WalletRemoteDataSource {
  Future<List<WalletDto>> addWallets({
    required String phoneNumber,
    required List<String> providers,
    required Map<String, double> initialBalances,
    required String deviceId,
  });

  Future<List<WalletDto>> getWallets();

  Stream<List<WalletDto>> watchWallets();

  Future<List<WalletDto>> getWalletsByIds(List<String> walletIds);

  Stream<List<WalletDto>> watchWalletsByIds(List<String> walletIds);

  Future<List<WalletDto>> getWalletsByOwnerAndProvider({
    required String ownerUid,
    required String provider,
  });

  Future<void> deleteWallet(String walletId);

  Future<void> resetWalletStats(String walletId);

  Future<void> updateWalletBalance({
    required String walletId,
    required double balance,
  });
}
