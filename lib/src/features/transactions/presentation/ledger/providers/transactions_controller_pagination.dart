part of 'transactions_controller.dart';

mixin _TransactionsControllerPagination on Notifier<TransactionsState> {
  TransactionsRouteData get arg;

  bool isStaleRequest(int requestId);

  int startRequest();

  int resolvePageSize(TransactionsRouteData routeData);

  Future<void> loadInitial({required int requestId}) async {
    state = state.copyWith(
      isLoadingInitial: true,
      isLoadingMore: false,
      error: null,
      transactions: const <TransactionEntity>[],
      totalCount: 0,
      nextCursor: null,
    );

    // Step 1 — Always attempt to fetch from Firestore first.
    switch (arg) {
      case WalletTransactionsRouteData():
        await loadWalletPage(
          arg as WalletTransactionsRouteData,
          isFirstPage: true,
          requestId: requestId,
        );
      case MultiWalletTransactionsRouteData():
        await loadWorkspacePage(
          arg as MultiWalletTransactionsRouteData,
          isFirstPage: true,
          requestId: requestId,
        );
    }

    if (isStaleRequest(requestId)) return;

    // Step 2 — Fallback to Hive cache ONLY if the remote fetch completely failed (e.g., no internet).
    // The cache is only populated for wallet context with no active filters.
    if (state.error != null) {
      final isWalletContext = arg is WalletTransactionsRouteData;
      final shouldTryCache = isWalletContext && !state.hasActiveFilter;

      if (shouldTryCache) {
        final walletId = (arg as WalletTransactionsRouteData).walletId;
        final cached = await ref.read(
          transactionFirstPageCacheProvider(walletId).future,
        );

        if (isStaleRequest(requestId)) return;

        if (cached != null) {
          // Rescue the view with the offline cached data.
          // Note: we intentionally keep the `error` state active so the UI can still
          // show a SnackBar or an offline indicator if desired, while not showing an empty list.
          state = state.copyWith(
            isLoadingInitial: false,
            transactions: cached.transactions,
            totalCount: cached.totalCount,
            nextCursor: null,
          );
        }
      }
    }
  }

  Future<void> loadWalletPage(
    WalletTransactionsRouteData context, {
    required bool isFirstPage,
    required int requestId,
  }) async {
    final result = await ref.read(getWalletTransactionsUseCaseProvider)(
      GetWalletTransactionsParams(
        walletId: context.walletId,
        type: state.resolvedType,
        paidStatusFilter: state.paidStatusFilter,
        counterpartySuffixQuery: state.counterpartySuffixQuery,
        dateRange: state.resolvedDateRange,
        limit: resolvePageSize(context),
        cursor: isFirstPage
            ? null
            : state.nextCursor as WalletTransactionsPageCursor?,
      ),
    );

    if (isStaleRequest(requestId)) return;
    result.fold(setLoadFailure, (page) {
      setPageSuccess(page: page, isFirstPage: isFirstPage);
    });
  }

  Future<void> loadWorkspacePage(
    MultiWalletTransactionsRouteData context, {
    required bool isFirstPage,
    required int requestId,
  }) async {
    final result = await ref.read(getTransactionsUseCaseProvider)(
      GetTransactionsParams(
        walletIds: resolveWorkspaceWalletIds(context),
        type: state.resolvedType,
        paidStatusFilter: state.paidStatusFilter,
        counterpartySuffixQuery: state.counterpartySuffixQuery,
        dateRange: state.resolvedDateRange,
        limit: resolvePageSize(context),
        cursor: isFirstPage
            ? null
            : state.nextCursor as MultiWalletTransactionsPageCursor?,
      ),
    );

    if (isStaleRequest(requestId)) return;
    result.fold(setLoadFailure, (page) {
      setPageSuccess(page: page, isFirstPage: isFirstPage);
    });
  }

  List<String> resolveWorkspaceWalletIds(
    MultiWalletTransactionsRouteData context,
  ) {
    final visibleWallets = state.useAllMembers
        ? context.wallets
        : context.wallets
              .where(
                (wallet) => state.selectedMemberUids.contains(wallet.memberId),
              )
              .toList();
    if (state.useAllWallets) {
      return visibleWallets.map((wallet) => wallet.walletId).toList();
    }

    return visibleWallets
        .where((wallet) => state.selectedWalletIds.contains(wallet.walletId))
        .map((wallet) => wallet.walletId)
        .toList();
  }

  void setLoadFailure(Failure failure) {
    log('TransactionsController: $failure', name: 'Presentation');
    state = state.copyWith(
      isLoadingInitial: false,
      isLoadingMore: false,
      error: failure,
    );
  }

  void setPageSuccess({
    required TransactionPage page,
    required bool isFirstPage,
  }) {
    final mergedTransactions = isFirstPage
        ? page.transactions
        : [
            ...state.transactions,
            ...page.transactions.where(
              (newTx) => !state.transactions.any(
                (oldTx) =>
                    oldTx.id == newTx.id && oldTx.walletId == newTx.walletId,
              ),
            ),
          ];
    state = state.copyWith(
      transactions: mergedTransactions,
      totalCount: page.totalCount,
      nextCursor: page.nextCursor,
      isLoadingInitial: false,
      isLoadingMore: false,
      error: null,
    );
  }

  Future<void> setCustomDatePreset({DateTime? start, DateTime? end}) async {
    if (start == null || end == null) return;

    state = state.copyWith(
      datePreset: DatePreset.custom,
      customDateRange: _DateRangeHelper.fromDates(start, end),
    );
    await loadInitial(requestId: startRequest());
  }
}

abstract final class _DateRangeHelper {
  static DateTimeRange fromDates(DateTime start, DateTime end) => DateTimeRange(
    start: DateTime(start.year, start.month, start.day),
    end: DateTime(end.year, end.month, end.day, 23, 59, 59),
  );
}
