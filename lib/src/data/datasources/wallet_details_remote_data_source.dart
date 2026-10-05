import '../models/wallet_dto.dart';

abstract interface class WalletDetailsRemoteDataSource {
  Future<WalletDto> getWallet(String walletId);
  Future<double?> getLatestActivityBalance(String walletId);
}
