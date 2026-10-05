import 'package:mahafez_core/mahafez_core.dart';
import '../repositories/wallet_repository.dart';

final class DeleteWalletUseCase implements UseCase<void, String> {
  const DeleteWalletUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Result<void>> call(String walletId) {
    return _repository.deleteWallet(walletId);
  }
}
