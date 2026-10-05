import '../models/wallet_dto.dart';

abstract interface class WalletRemoteDataSource {
  Future<List<WalletDto>> addWallets({
    required String phoneNumber,
    required List<String> providers,
    required Map<String, double> initialBalances,
    required String deviceId,
  });

  Future<List<WalletDto>> getWallets();

  Future<void> deleteWallet(String walletId);

  Future<void> resetWalletStats(String walletId);

  Future<void> updateWalletBalance({
    required String walletId,
    required double balance,
  });
}
