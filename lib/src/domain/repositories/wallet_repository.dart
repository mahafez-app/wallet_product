import 'package:mahafez_core/mahafez_core.dart';
import '../entities/wallet_details_entity.dart';
import '../entities/wallet_entity.dart';

abstract interface class WalletRepository {
  Future<Result<List<WalletEntity>>> getWallets();

  Future<Result<void>> addWallets({
    required String phoneNumber,
    required List<String> providers,
    Map<String, double> initialBalances,
  });

  Future<Result<WalletDetailsEntity>> getWalletDetails(String walletId);

  Future<Result<void>> deleteWallet(String walletId);

  Future<Result<void>> resetWalletStats(String walletId);

  Future<Result<void>> updateWalletBalance({
    required String walletId,
    required double balance,
  });
}
