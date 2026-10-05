import 'package:mahafez_core/mahafez_core.dart';
import '../repositories/wallet_repository.dart';

final class AddWalletsParams {
  final String phoneNumber;
  final List<String> providers;
  final Map<String, double> initialBalances;

  const AddWalletsParams({
    required this.phoneNumber,
    required this.providers,
    this.initialBalances = const {},
  });
}

final class AddWalletsUseCase implements UseCase<void, AddWalletsParams> {
  final WalletRepository _repository;

  const AddWalletsUseCase(this._repository);

  @override
  Future<Result<void>> call(AddWalletsParams params) {
    return _repository.addWallets(
      phoneNumber: params.phoneNumber,
      providers: params.providers,
      initialBalances: params.initialBalances,
    );
  }
}
