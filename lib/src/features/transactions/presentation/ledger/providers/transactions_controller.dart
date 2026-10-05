import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mahafez_core/mahafez_core.dart';
import 'draft_filters_controller.dart';
import '../../controllers/transaction_events_provider.dart';
import '../../controllers/transaction_providers.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../../domain/entities/transaction_page.dart';
import '../../../domain/entities/transaction_paid_status_filter.dart';
import '../../../domain/usecases/get_transactions_usecase.dart';
import '../../../domain/usecases/get_wallet_transactions_usecase.dart';
import '../navigation/transactions_route_data.dart';
import 'transactions_state.dart';

part 'transactions_controller_live_sync.dart';
part 'transactions_controller_pagination.dart';

final transactionsControllerProvider = NotifierProvider.autoDispose
    .family<TransactionsController, TransactionsState, TransactionsRouteData>(
      TransactionsController.new,
    );

class TransactionsController extends Notifier<TransactionsState>
    with _TransactionsControllerPagination, _TransactionsControllerLiveSync {
  TransactionsController(this.arg);

  static const int walletPageSize = 10;
  static const int multiWalletPageSize = 5;

  @override
  final TransactionsRouteData arg;
  bool _didScheduleInitialLoad = false;
  int _activeRequestId = 0;

  @override
  TransactionsState build() {
    bindTransactionUpdates();
    _scheduleInitialLoad();
    return const TransactionsState();
  }

  void _scheduleInitialLoad() {
    if (_didScheduleInitialLoad) return;
    _didScheduleInitialLoad = true;
    Future<void>(() => loadInitial(requestId: startRequest()));
  }

  @override
  int startRequest() => ++_activeRequestId;

  @override
  bool isStaleRequest(int requestId) =>
      !ref.mounted || requestId != _activeRequestId;

  @override
  int resolvePageSize(TransactionsRouteData routeData) => switch (routeData) {
    WalletTransactionsRouteData() => walletPageSize,
    MultiWalletTransactionsRouteData() => multiWalletPageSize,
  };

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);
    switch (arg) {
      case WalletTransactionsRouteData():
        await loadWalletPage(
          arg as WalletTransactionsRouteData,
          isFirstPage: false,
          requestId: _activeRequestId,
        );
      case MultiWalletTransactionsRouteData():
        await loadWorkspacePage(
          arg as MultiWalletTransactionsRouteData,
          isFirstPage: false,
          requestId: _activeRequestId,
        );
    }
  }

  Future<void> setTypeFilter(TransactionTypeFilter filter) async {
    final resolvedTypeFilter = state.typeFilter == filter
        ? TransactionTypeFilter.all
        : filter;
    state = state.copyWith(
      typeFilter: resolvedTypeFilter,
      paidStatusFilter: resolvedTypeFilter == TransactionTypeFilter.send
          ? TransactionPaidStatusFilter.all
          : state.paidStatusFilter,
    );
    await loadInitial(requestId: startRequest());
  }

  Future<void> setPaidStatusFilter(TransactionPaidStatusFilter filter) async {
    final resolvedPaidStatusFilter = state.paidStatusFilter == filter
        ? TransactionPaidStatusFilter.all
        : filter;
    state = state.copyWith(
      paidStatusFilter: resolvedPaidStatusFilter,
      typeFilter: resolvedPaidStatusFilter == TransactionPaidStatusFilter.all
          ? state.typeFilter
          : TransactionTypeFilter.receive,
    );
    await loadInitial(requestId: startRequest());
  }

  Future<void> setCounterpartySuffixQuery(String query) async {
    final normalizedQuery = _normalizeDigits(query);
    final resolvedQuery = normalizedQuery.isEmpty ? null : normalizedQuery;
    if (state.counterpartySuffixQuery == resolvedQuery) {
      return;
    }

    state = state.copyWith(counterpartySuffixQuery: resolvedQuery);
    await loadInitial(requestId: startRequest());
  }

  Future<void> selectAllMembers() async {
    if (state.useAllMembers && state.selectedMemberUids.isEmpty) return;
    state = state.copyWith(
      useAllMembers: true,
      selectedMemberUids: const <String>[],
      useAllWallets: true,
      selectedWalletIds: const <String>[],
    );
    await loadInitial(requestId: startRequest());
  }

  Future<void> toggleMemberFilter(String memberUid) async {
    if (arg is! MultiWalletTransactionsRouteData) return;

    final currentSelection = state.useAllMembers
        ? <String>{memberUid}
        : state.selectedMemberUids.toSet();

    if (!state.useAllMembers && !currentSelection.add(memberUid)) {
      currentSelection.remove(memberUid);
    }

    state = _resolveMemberSelectionState(currentSelection);
    await loadInitial(requestId: startRequest());
  }

  TransactionsState _resolveMemberSelectionState(
    Set<String> selectedMemberUids,
  ) {
    if (selectedMemberUids.isEmpty) {
      return state.copyWith(
        useAllMembers: true,
        selectedMemberUids: const <String>[],
        useAllWallets: true,
        selectedWalletIds: const <String>[],
      );
    }

    return state.copyWith(
      useAllMembers: false,
      selectedMemberUids: selectedMemberUids.toList(),
      useAllWallets: true, // Reset wallets when members change
      selectedWalletIds: const <String>[],
    );
  }

  Future<void> setDatePreset(
    DatePreset preset, {
    DateTime? start,
    DateTime? end,
  }) async {
    if (preset == DatePreset.custom) {
      await setCustomDatePreset(start: start, end: end);
      return;
    }
    if (state.datePreset == preset && preset != DatePreset.custom) {
      await clearDatePreset();
      return;
    }

    state = state.copyWith(datePreset: preset, customDateRange: null);
    await loadInitial(requestId: startRequest());
  }

  Future<void> clearDatePreset() async {
    if (state.datePreset == DatePreset.none && state.customDateRange == null) {
      return;
    }

    state = state.copyWith(datePreset: DatePreset.none, customDateRange: null);
    await loadInitial(requestId: startRequest());
  }

  Future<void> selectAllWallets() async {
    if (state.useAllWallets && state.selectedWalletIds.isEmpty) return;
    state = state.copyWith(
      useAllWallets: true,
      selectedWalletIds: const <String>[],
    );
    await loadInitial(requestId: startRequest());
  }

  Future<void> toggleWalletFilter(String walletId) async {
    if (arg is! MultiWalletTransactionsRouteData) return;

    final currentSelection = state.useAllWallets
        ? <String>{walletId}
        : state.selectedWalletIds.toSet();

    if (!state.useAllWallets && !currentSelection.add(walletId)) {
      currentSelection.remove(walletId);
    }

    state = _resolveWalletSelectionState(currentSelection);
    await loadInitial(requestId: startRequest());
  }

  TransactionsState _resolveWalletSelectionState(
    Set<String> selectedWalletIds,
  ) {
    if (selectedWalletIds.isEmpty) {
      return state.copyWith(
        useAllWallets: true,
        selectedWalletIds: const <String>[],
      );
    }

    final orderedSelection = _visibleMultiWallets
        .where((wallet) => selectedWalletIds.contains(wallet.walletId))
        .map((wallet) => wallet.walletId)
        .toList();

    return state.copyWith(
      useAllWallets: false,
      selectedWalletIds: orderedSelection,
    );
  }

  Future<void> applyDraftFilters(DraftFiltersState draft) async {
    state = state.copyWith(
      typeFilter: draft.typeFilter,
      paidStatusFilter: draft.paidStatusFilter,
      datePreset: draft.datePreset,
      customDateRange: draft.customDateRange,
      counterpartySuffixQuery: draft.counterpartySuffixQuery,
      useAllMembers: draft.useAllMembers,
      selectedMemberUids: draft.selectedMemberUids,
      useAllWallets: draft.useAllWallets,
      selectedWalletIds: draft.selectedWalletIds,
    );
    await loadInitial(requestId: startRequest());
  }

  Future<void> clearAllFilters() async {
    state = const TransactionsState();
    await loadInitial(requestId: startRequest());
  }

  List<TransactionWalletFilterOption> get _visibleMultiWallets {
    if (arg is! MultiWalletTransactionsRouteData) {
      return const <TransactionWalletFilterOption>[];
    }

    final routeData = arg as MultiWalletTransactionsRouteData;
    if (state.useAllMembers) {
      return routeData.wallets;
    }

    return routeData.wallets
        .where((wallet) => state.selectedMemberUids.contains(wallet.memberId))
        .toList();
  }

  String _normalizeDigits(String value) {
    final buffer = StringBuffer();
    for (final codeUnit in value.codeUnits) {
      final isDigit = codeUnit >= 48 && codeUnit <= 57;
      if (isDigit) {
        buffer.writeCharCode(codeUnit);
      }
    }
    return buffer.toString();
  }
}
