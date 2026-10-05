import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../controllers/add_wallet_controller.dart';
import '../controllers/add_wallet_state.dart';
import '../../../../shared/utils/localization_extension.dart';
import '../widgets/add_wallet_content.dart';

class AddWalletScreen extends StatelessWidget {
  const AddWalletScreen({
    super.key,
    required this.onSuccess,
    this.onError,
  });

  final VoidCallback onSuccess;
  final void Function(Failure failure)? onError;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addWalletTitle), centerTitle: true),
      body: SafeArea(
        child: _AddWalletBody(
          onSuccess: onSuccess,
          onError: onError,
        ),
      ),
    );
  }
}

class _AddWalletBody extends ConsumerWidget {
  const _AddWalletBody({
    required this.onSuccess,
    this.onError,
  });

  final VoidCallback onSuccess;
  final void Function(Failure failure)? onError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AddWalletState>(addWalletControllerProvider, (previous, next) {
      if (_hasNewSubmissionFailure(previous, next)) {
        if (onError != null) {
          onError!(next.submissionFailure!);
        } else {
          MahafezSnackbar.showFailure(context, failure: next.submissionFailure!);
        }
        return;
      }

      if (_hasSuccessfulSubmission(previous, next)) {
        onSuccess();
      }
    });

    final state = ref.watch(addWalletControllerProvider);
    final controller = ref.read(addWalletControllerProvider.notifier);

    return AddWalletContent(
      state: state,
      onPhoneNumberChanged: controller.updatePhoneNumber,
      onProviderToggled: controller.toggleProvider,
      onSubmit: controller.submit,
    );
  }

  bool _hasNewSubmissionFailure(AddWalletState? previous, AddWalletState next) {
    return next.submissionStatus == .failure &&
        previous?.submissionFailure != next.submissionFailure &&
        next.submissionFailure != null;
  }

  bool _hasSuccessfulSubmission(AddWalletState? previous, AddWalletState next) {
    return previous?.submissionStatus != .success &&
        next.submissionStatus == .success;
  }
}
