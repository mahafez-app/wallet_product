import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/transaction_entity.dart';
import '../../domain/usecases/get_wallet_transactions_usecase.dart';
import 'transaction_providers.dart';

/// Loads the latest 5 transactions for [walletId].
/// Auto-disposes when the wallet detail screen is closed.
final recentTransactionsProvider = AsyncNotifierProvider.autoDispose
    .family<RecentTransactionsNotifier, List<TransactionEntity>, String>(
      RecentTransactionsNotifier.new,
    );

class RecentTransactionsNotifier
    extends AsyncNotifier<List<TransactionEntity>> {
  RecentTransactionsNotifier(this._walletId);

  final String _walletId;

  @override
  Future<List<TransactionEntity>> build() async {
    final result = await ref.read(getWalletTransactionsUseCaseProvider)(
      GetWalletTransactionsParams(walletId: _walletId, limit: 5),
    );

    return result.fold(
      (failure) => throw failure,
      (page) => page.transactions,
    );
  }

  /// Call this to update a single transaction in the list without a full refetch.
  void applyUpdatedTransaction(TransactionEntity updated) {
    final current = state.asData?.value;
    if (current == null) return;

    final index = current.indexWhere((t) => t.id == updated.id);
    if (index == -1) return;

    final updatedList = List<TransactionEntity>.of(current);
    updatedList[index] = updated;
    state = AsyncValue.data(updatedList);
  }

  /// Call this to refresh the list (e.g., after a transaction is deleted).
  void refresh() => ref.invalidateSelf();
}
