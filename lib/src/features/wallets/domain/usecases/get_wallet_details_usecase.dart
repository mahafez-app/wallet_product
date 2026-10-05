import 'package:mahafez_core/mahafez_core.dart';
import '../entities/wallet_entity.dart';
import '../repositories/wallet_repository.dart';

final class GetWalletDetailsParams {
  final String walletId;

  const GetWalletDetailsParams({required this.walletId});
}

final class GetWalletDetailsUseCase
    implements UseCase<WalletEntity, GetWalletDetailsParams> {
  final WalletRepository _repository;

  const GetWalletDetailsUseCase(this._repository);

  @override
  Future<Result<WalletEntity>> call(GetWalletDetailsParams params) {
    return _repository.getWalletDetails(params.walletId);
  }
}
