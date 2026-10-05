import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahafez_core/mahafez_core.dart';

import '../../domain/usecases/add_wallets_usecase.dart';
import 'add_wallet_state.dart';
import 'wallet_providers.dart';

final addWalletControllerProvider =
    NotifierProvider.autoDispose<AddWalletController, AddWalletState>(
      AddWalletController.new,
    );

class AddWalletController extends Notifier<AddWalletState> {
  @override
  AddWalletState build() {
    return const AddWalletState.initial();
  }

  void updatePhoneNumber(String phoneNumber) {
    final normalizedPhoneNumber = EgyptianPhoneNumber.normalize(phoneNumber);
    state = state.copyWith(
      phoneNumber: normalizedPhoneNumber,
      selectedProviders: _resolveSelectedProviders(
        phoneNumber: normalizedPhoneNumber,
        currentProviders: state.selectedProviders,
      ),
      submissionStatus: .idle,
      submissionFailure: null,
    );
  }

  void toggleProvider(WalletProvider provider) {
    if (!state.allowedProviders.contains(provider)) return;

    final selectedProviders = Set<WalletProvider>.of(state.selectedProviders);
    if (selectedProviders.contains(provider)) {
      selectedProviders.remove(provider);
    } else {
      selectedProviders.add(provider);
    }

    state = state.copyWith(
      selectedProviders: selectedProviders,
      submissionStatus: .idle,
      submissionFailure: null,
    );
  }

  void submit() {
    final validationFailure = _validate(state);
    if (validationFailure != null) {
      _setSubmissionFailure(validationFailure);
      return;
    }

    final currentState = state;
    state = state.copyWith(
      submissionStatus: .loading,
      submissionFailure: null,
    );
    unawaited(_submitValidated(currentState));
  }

  Failure? _validate(AddWalletState currentState) {
    if (currentState.phoneNumber.isEmpty) {
      return const ValidationFailure(code: 'wallet-phone-required');
    }

    if (!currentState.hasValidPhoneNumber) {
      return const ValidationFailure(code: 'wallet-phone-invalid');
    }

    if (currentState.selectedProviders.isEmpty) {
      return const ValidationFailure(code: 'wallet-provider-required');
    }

    if (!currentState.allowedProviders.containsAll(
      currentState.selectedProviders,
    )) {
      return const ValidationFailure(code: 'wallet-provider-mismatch');
    }

    return null;
  }

  void _setSubmissionFailure(Failure failure) {
    state = state.copyWith(
      submissionStatus: .failure,
      submissionFailure: failure,
    );
  }

  Future<void> _submitValidated(AddWalletState currentState) async {
    final result = await ref.read(addWalletsUseCaseProvider)(
      AddWalletsParams(
        phoneNumber: currentState.phoneNumber,
        providers: currentState.selectedProviders
            .map((provider) => provider.toValue)
            .toList(),
      ),
    );

    if (!ref.mounted) return;

    result.fold(_setSubmissionFailure, (_) => _setSubmissionSuccess());
  }

  void _setSubmissionSuccess() {
    state = state.copyWith(
      phoneNumber: '',
      selectedProviders: const <WalletProvider>{},
      submissionStatus: .success,
      submissionFailure: null,
    );
  }

  Set<WalletProvider> _resolveSelectedProviders({
    required String phoneNumber,
    Set<WalletProvider> currentProviders = const <WalletProvider>{},
  }) {
    final allowedProviders = EgyptianPhoneNumber.allowedProviders(phoneNumber);
    if (allowedProviders.isEmpty) return const <WalletProvider>{};

    final selectedProviders = currentProviders
        .where(allowedProviders.contains)
        .toSet();
    if (selectedProviders.isNotEmpty) return selectedProviders;

    final primaryProvider = EgyptianPhoneNumber.primaryProvider(phoneNumber);
    if (primaryProvider == null) return const <WalletProvider>{};

    return {primaryProvider};
  }
}
