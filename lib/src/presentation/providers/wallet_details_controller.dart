import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/wallet_entity.dart';
import '../../domain/usecases/get_wallet_details_usecase.dart';
import 'wallet_providers.dart';

final walletDetailsControllerProvider = AsyncNotifierProvider.autoDispose
    .family<WalletDetailsController, WalletEntity, String>(
      WalletDetailsController.new,
    );

class WalletDetailsController extends AsyncNotifier<WalletEntity> {
  WalletDetailsController(this._walletId);

  final String _walletId;

  @override
  Future<WalletEntity> build() async {
    final result = await ref.read(getWalletDetailsUseCaseProvider)(
      GetWalletDetailsParams(walletId: _walletId),
    );

    return result.fold(
      (failure) => throw failure,
      (wallet) => wallet,
    );
  }

  Future<void> resetStats() async {
    final result = await ref.read(resetWalletStatsUseCaseProvider)(_walletId);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => ref.invalidateSelf(),
    );
  }
}
