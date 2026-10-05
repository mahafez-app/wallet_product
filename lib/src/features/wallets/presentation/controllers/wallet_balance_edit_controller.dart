import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahafez_core/mahafez_core.dart';

import '../../domain/usecases/update_wallet_balance_usecase.dart';
import 'wallet_providers.dart';

enum WalletBalanceEditStatus { idle, loading, success, failure }

const _unsetFailure = Object();

final walletBalanceEditControllerProvider = NotifierProvider.autoDispose
    .family<WalletBalanceEditController, WalletBalanceEditState, String>(
      WalletBalanceEditController.new,
    );

final class WalletBalanceEditState {
  const WalletBalanceEditState({required this.status, required this.failure});

  const WalletBalanceEditState.initial()
    : status = .idle,
      failure = null;

  final WalletBalanceEditStatus status;
  final Failure? failure;

  bool get isSubmitting => status == .loading;

  WalletBalanceEditState copyWith({
    WalletBalanceEditStatus? status,
    Object? failure = _unsetFailure,
  }) {
    return WalletBalanceEditState(
      status: status ?? this.status,
      failure: identical(failure, _unsetFailure)
          ? this.failure
          : failure as Failure?,
    );
  }
}

final class WalletBalanceEditController
    extends Notifier<WalletBalanceEditState> {
  WalletBalanceEditController(this._walletId);

  final String _walletId;

  @override
  WalletBalanceEditState build() => const WalletBalanceEditState.initial();

  Future<void> updateBalance(double balance) async {
    state = state.copyWith(
      status: .loading,
      failure: null,
    );

    final result = await ref.read(updateWalletBalanceUseCaseProvider)(
      UpdateWalletBalanceParams(walletId: _walletId, balance: balance),
    );
    result.fold(
      (failure) => state = state.copyWith(
        status: .failure,
        failure: failure,
      ),
      (_) => state = state.copyWith(
        status: .success,
        failure: null,
      ),
    );
  }
}
