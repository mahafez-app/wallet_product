import 'package:flutter/widgets.dart';
import 'package:mahafez_core/mahafez_core.dart';

import 'localization_extension.dart';

extension FailureMessaging on BuildContext {
  String failureMessage(Failure failure) {
    final l10n = this.l10n;
    return switch (failure) {
      NetworkFailure() => l10n.errorNetwork,
      AuthFailure(:final code) => switch (code) {
        'user-not-found' => l10n.errorAuthUserNotFound,
        'wrong-password' => l10n.errorAuthWrongPassword,
        'email-already-in-use' => l10n.errorAuthEmailInUse,
        'too-many-requests' => l10n.errorAuthTooManyRequests,
        'user-disabled' => l10n.errorAuthUserDisabled,
        'weak-password' => l10n.errorAuthWeakPassword,
        'invalid-email' => l10n.errorAuthInvalidEmail,
        '401' => l10n.errorUnauthorized,
        _ => l10n.errorAuthGeneric,
      },
      ServerFailure(:final code) => switch (code) {
        '403' => l10n.errorForbidden,
        '404' => l10n.errorNotFound,
        '409' => l10n.errorConflict,
        '422' => l10n.errorUnprocessable,
        '500' => l10n.errorServer,
        _ => l10n.errorServerGeneric,
      },
      PermissionFailure() => l10n.errorPermissionDenied,
      CacheFailure() => l10n.errorCache,
      StorageFailure() => l10n.errorStorage,
      ValidationFailure(:final code) => switch (code) {
        'wallet-phone-required' => l10n.errorWalletPhoneNumberRequired,
        'wallet-phone-invalid' => l10n.errorWalletPhoneNumberInvalid,
        'wallet-provider-required' => l10n.errorWalletProviderRequired,
        'wallet-provider-mismatch' => l10n.errorWalletProviderMismatch,
        'wallet-already-exists' => l10n.errorWalletAlreadyExists,
        'wallet-all-exists' => l10n.errorWalletAllExists,
        'manual-transaction-message-required' =>
          l10n.errorManualTransactionMessageRequired,
        'manual-transaction-unrecognized' =>
          l10n.errorManualTransactionUnrecognized,
        'manual-transaction-wallet-mismatch' =>
          l10n.errorManualTransactionWalletMismatch,
        'transaction-not-found' => l10n.errorTransactionNotFound,
        'transaction-already-exists' => l10n.errorTransactionAlreadyExists,
        'transaction-locally-deleted' => l10n.errorTransactionAlreadyExists,
        _ => l10n.errorValidation,
      },
      UnknownFailure() => l10n.errorUnknown,
    };
  }
}

extension FailureDisplay on Failure {
  String toLocalizedString(BuildContext context) =>
      context.failureMessage(this);
}
