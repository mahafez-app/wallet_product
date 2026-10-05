import 'package:mahafez_core/mahafez_core.dart';

const unsetFailure = Object();

enum AddWalletSubmissionStatus { idle, loading, success, failure }

final class AddWalletState {
  const AddWalletState({
    required this.phoneNumber,
    required this.selectedProviders,
    required this.submissionStatus,
    required this.submissionFailure,
  });

  const AddWalletState.initial()
    : phoneNumber = '',
      selectedProviders = const <WalletProvider>{},
      submissionStatus = AddWalletSubmissionStatus.idle,
      submissionFailure = null;

  final String phoneNumber;
  final Set<WalletProvider> selectedProviders;
  final AddWalletSubmissionStatus submissionStatus;
  final Failure? submissionFailure;

  bool get isSubmitting =>
      submissionStatus == AddWalletSubmissionStatus.loading;

  bool get hasValidPhoneNumber =>
      EgyptianPhoneNumber.isValidMobileNumber(phoneNumber);

  Set<WalletProvider> get allowedProviders =>
      EgyptianPhoneNumber.allowedProviders(phoneNumber);

  AddWalletState copyWith({
    String? phoneNumber,
    Set<WalletProvider>? selectedProviders,
    AddWalletSubmissionStatus? submissionStatus,
    Object? submissionFailure = unsetFailure,
  }) {
    return AddWalletState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      selectedProviders: selectedProviders ?? this.selectedProviders,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      submissionFailure: identical(submissionFailure, unsetFailure)
          ? this.submissionFailure
          : submissionFailure as Failure?,
    );
  }
}
