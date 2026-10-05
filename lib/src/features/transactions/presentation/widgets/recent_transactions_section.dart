import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../../../shared/utils/localization_extension.dart';
import '../../../wallets/domain/entities/wallet_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../controllers/recent_transactions_provider.dart';
import 'transaction_card.dart';

/// Displays the 5 most recent transactions for [wallet].
///
/// * [onViewAllPressed] — called when the "View All" button is tapped.
///   If null, the button is hidden.
/// * [onTransactionTap] — called when the user taps a transaction row.
///   If null, rows are not tappable.
class RecentTransactionsSection extends ConsumerWidget {
  const RecentTransactionsSection({
    super.key,
    required this.wallet,
    this.onViewAllPressed,
    this.onTransactionTap,
  });

  final WalletEntity wallet;
  final VoidCallback? onViewAllPressed;
  final void Function(TransactionEntity transaction)? onTransactionTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recentTransactionsProvider(wallet.id));

    return state.when(
      loading: () => const MahafezLoader(),
      error: (error, _) => MahafezErrorView(error: error),
      data: (transactions) => _TransactionsBody(
        wallet: wallet,
        recentTransactions: transactions,
        onViewAllPressed: onViewAllPressed,
        onTransactionTap: onTransactionTap,
      ),
    );
  }
}

class _TransactionsBody extends StatelessWidget {
  const _TransactionsBody({
    required this.wallet,
    required this.recentTransactions,
    this.onViewAllPressed,
    this.onTransactionTap,
  });

  final WalletEntity wallet;
  final List<TransactionEntity> recentTransactions;
  final VoidCallback? onViewAllPressed;
  final void Function(TransactionEntity transaction)? onTransactionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final hasTransactions = recentTransactions.isNotEmpty;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.recentTransactions,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (hasTransactions && onViewAllPressed != null)
              TextButton(
                onPressed: onViewAllPressed,
                child: Text(
                  l10n.viewAll,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
        MahafezSpacing.md.verticalSpace,
        if (!hasTransactions)
          _NoTransactionsPlaceholder(l10n: l10n)
        else
          ...recentTransactions.map(
            (transaction) => GestureDetector(
              onTap: onTransactionTap != null
                  ? () => onTransactionTap!(transaction)
                  : null,
              child: TransactionCard(
                transaction: transaction,
                showProviderInfo: false,
              ),
            ),
          ),
      ],
    );
  }
}

class _NoTransactionsPlaceholder extends StatelessWidget {
  const _NoTransactionsPlaceholder({required this.l10n});

  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: MahafezResponsive.allPadding(MahafezSpacing.xl),
        child: Text(
          l10n.transactions_emptyWalletDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
