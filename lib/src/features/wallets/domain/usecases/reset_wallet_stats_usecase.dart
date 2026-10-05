import 'package:mahafez_core/mahafez_core.dart';
import '../repositories/wallet_repository.dart';

final class ResetWalletStatsUseCase implements UseCase<void, String> {
  const ResetWalletStatsUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<void>> call(String walletId) {
    return _repository.resetWalletStats(walletId);
  }
}
