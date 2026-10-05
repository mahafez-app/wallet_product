import 'package:mahafez_core/mahafez_core.dart';
import '../entities/wallet_entity.dart';
import '../repositories/wallet_repository.dart';

final class GetWalletsUseCase implements NoParamsUseCase<List<WalletEntity>> {
  final WalletRepository _repository;

  const GetWalletsUseCase(this._repository);

  @override
  Future<Result<List<WalletEntity>>> call() {
    return _repository.getWallets();
  }
}
