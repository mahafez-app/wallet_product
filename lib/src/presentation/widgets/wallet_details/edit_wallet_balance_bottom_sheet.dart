import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../../localization/wallet_localization.dart';
import '../../providers/wallet_balance_edit_controller.dart';
import '../../providers/wallet_details_controller.dart';
import '../../utils/amount_extension.dart';

class EditWalletBalanceBottomSheet extends StatelessWidget {
  const EditWalletBalanceBottomSheet({
    super.key,
    required this.walletId,
    required this.currentBalance,
    required this.suggestedBalance,
  });

  final String walletId;
  final double currentBalance;
  final double suggestedBalance;

  static Future<void> show(
    BuildContext context, {
    required String walletId,
    required double currentBalance,
    required double suggestedBalance,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EditWalletBalanceBottomSheet(
          walletId: walletId,
          currentBalance: currentBalance,
          suggestedBalance: suggestedBalance,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _EditWalletBalanceBottomSheetBody(
      walletId: walletId,
      currentBalance: currentBalance,
      suggestedBalance: suggestedBalance,
    );
  }
}

class _EditWalletBalanceBottomSheetBody extends ConsumerStatefulWidget {
  const _EditWalletBalanceBottomSheetBody({
    required this.walletId,
    required this.currentBalance,
    required this.suggestedBalance,
  });

  final String walletId;
  final double currentBalance;
  final double suggestedBalance;

  @override
  ConsumerState<_EditWalletBalanceBottomSheetBody> createState() =>
      _EditWalletBalanceBottomSheetBodyState();
}

class _EditWalletBalanceBottomSheetBodyState
    extends ConsumerState<_EditWalletBalanceBottomSheetBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _balanceController;

  @override
  void initState() {
    super.initState();
    _balanceController = TextEditingController(
      text: _formatBalance(widget.suggestedBalance),
    );
  }

  @override
  void dispose() {
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<WalletBalanceEditState>(
      walletBalanceEditControllerProvider(widget.walletId),
      (previous, next) {
        if (_hasNewFailure(previous, next) && next.failure != null) {
          MahafezSnackbar.showFailure(context, failure: next.failure!);
        }

        if (_hasCompletedSuccess(previous, next) && context.mounted) {
          ref.invalidate(walletDetailsControllerProvider(widget.walletId));
          MahafezSnackbar.show(
            context,
            message: context.walletL10n.walletBalanceEditSuccess,
            type: .success,
          );
          Navigator.of(context).pop();
        }
      },
    );

    final editState = ref.watch(
      walletBalanceEditControllerProvider(widget.walletId),
    );
    final theme = Theme.of(context);
    final l10n = context.walletL10n;

    return Padding(
      padding: MahafezResponsive.allPadding(MahafezSpacing.xl),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.walletBalanceEditAction,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: editState.isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            MahafezSpacing.md.verticalSpace,
            Text(
              '${l10n.currentBalance}: ${widget.currentBalance.toWalletCurrencyText(context)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            MahafezSpacing.lg.verticalSpace,
            MahafezTextField(
              controller: _balanceController,
              label: l10n.currentBalance,
              hintText: l10n.currentBalance,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                final normalized = value?.trim().replaceAll(',', '') ?? '';
                final parsed = double.tryParse(normalized);
                if (parsed == null || parsed < 0) {
                  return 'يرجى إدخال مبلغ صحيح';
                }
                return null;
              },
            ),
            MahafezSpacing.xl.verticalSpace,
            MahafezButton(
              label: 'حفظ الرصيد',
              isLoading: editState.isSubmitting,
              onPressed: () {
                if (_formKey.currentState?.validate() != true) return;
                final normalized =
                    _balanceController.text.trim().replaceAll(',', '');
                final parsed = double.tryParse(normalized);
                if (parsed == null) return;

                ref
                    .read(
                      walletBalanceEditControllerProvider(widget.walletId)
                          .notifier,
                    )
                    .updateBalance(parsed);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatBalance(double balance) {
    if (balance == balance.roundToDouble()) {
      return balance.toInt().toString();
    }
    return balance.toStringAsFixed(2);
  }

  bool _hasNewFailure(
    WalletBalanceEditState? previous,
    WalletBalanceEditState next,
  ) {
    return previous?.status != .failure && next.status == .failure;
  }

  bool _hasCompletedSuccess(
    WalletBalanceEditState? previous,
    WalletBalanceEditState next,
  ) {
    return previous?.status != .success && next.status == .success;
  }
}
