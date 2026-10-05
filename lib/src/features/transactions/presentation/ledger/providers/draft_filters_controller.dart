import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../navigation/transactions_route_data.dart';
import 'transactions_controller.dart';
import 'transactions_state.dart';
import '../../../domain/entities/transaction_paid_status_filter.dart';

class DraftFiltersState extends Equatable {
  const DraftFiltersState({
    this.typeFilter = TransactionTypeFilter.all,
    this.paidStatusFilter = TransactionPaidStatusFilter.all,
    this.datePreset = DatePreset.none,
    this.customDateRange,
    this.counterpartySuffixQuery,
    this.useAllMembers = true,
    this.selectedMemberUids = const <String>[],
    this.useAllWallets = true,
    this.selectedWalletIds = const <String>[],
  });

  final TransactionTypeFilter typeFilter;
  final TransactionPaidStatusFilter paidStatusFilter;
  final DatePreset datePreset;
  final DateTimeRange? customDateRange;
  final String? counterpartySuffixQuery;
  final bool useAllMembers;
  final List<String> selectedMemberUids;
  final bool useAllWallets;
  final List<String> selectedWalletIds;

  @override
  List<Object?> get props => [
    typeFilter,
    paidStatusFilter,
    datePreset,
    customDateRange,
    counterpartySuffixQuery,
    useAllMembers,
    selectedMemberUids,
    useAllWallets,
    selectedWalletIds,
  ];

  DraftFiltersState copyWith({
    TransactionTypeFilter? typeFilter,
    TransactionPaidStatusFilter? paidStatusFilter,
    DatePreset? datePreset,
    DateTimeRange? customDateRange,
    String? counterpartySuffixQuery,
    bool? useAllMembers,
    List<String>? selectedMemberUids,
    bool? useAllWallets,
    List<String>? selectedWalletIds,
  }) {
    return DraftFiltersState(
      typeFilter: typeFilter ?? this.typeFilter,
      paidStatusFilter: paidStatusFilter ?? this.paidStatusFilter,
      datePreset: datePreset ?? this.datePreset,
      customDateRange: customDateRange ?? this.customDateRange,
      counterpartySuffixQuery:
          counterpartySuffixQuery ?? this.counterpartySuffixQuery,
      useAllMembers: useAllMembers ?? this.useAllMembers,
      selectedMemberUids: selectedMemberUids ?? this.selectedMemberUids,
      useAllWallets: useAllWallets ?? this.useAllWallets,
      selectedWalletIds: selectedWalletIds ?? this.selectedWalletIds,
    );
  }

  DraftFiltersState clearCounterparty() {
    return DraftFiltersState(
      typeFilter: typeFilter,
      paidStatusFilter: paidStatusFilter,
      datePreset: datePreset,
      customDateRange: customDateRange,
      counterpartySuffixQuery: null,
      useAllMembers: useAllMembers,
      selectedMemberUids: selectedMemberUids,
      useAllWallets: useAllWallets,
      selectedWalletIds: selectedWalletIds,
    );
  }

  // Removed clearMember as we handle it generically now if needed.
}

final draftFiltersControllerProvider = NotifierProvider.autoDispose
    .family<DraftFiltersController, DraftFiltersState, TransactionsRouteData>(
      DraftFiltersController.new,
    );

class DraftFiltersController extends Notifier<DraftFiltersState> {
  DraftFiltersController(this.arg);
  final TransactionsRouteData arg;

  @override
  DraftFiltersState build() {
    final mainState = ref.watch(transactionsControllerProvider(arg));
    return DraftFiltersState(
      typeFilter: mainState.typeFilter,
      paidStatusFilter: mainState.paidStatusFilter,
      datePreset: mainState.datePreset,
      customDateRange: mainState.customDateRange,
      counterpartySuffixQuery: mainState.counterpartySuffixQuery,
      useAllMembers: mainState.useAllMembers,
      selectedMemberUids: mainState.selectedMemberUids,
      useAllWallets: mainState.useAllWallets,
      selectedWalletIds: mainState.selectedWalletIds,
    );
  }

  void setTypeFilter(TransactionTypeFilter type) {
    if (state.typeFilter == type) {
      state = state.copyWith(typeFilter: TransactionTypeFilter.all);
    } else {
      state = state.copyWith(typeFilter: type);
    }
  }

  void setPaidStatusFilter(TransactionPaidStatusFilter filter) {
    if (state.paidStatusFilter == filter) {
      state = state.copyWith(paidStatusFilter: TransactionPaidStatusFilter.all);
    } else {
      state = state.copyWith(paidStatusFilter: filter);
    }
  }

  void setDatePreset(DatePreset preset, {DateTimeRange? customRange}) {
    if (state.datePreset == preset && preset != DatePreset.custom) {
      state = state.copyWith(
        datePreset: DatePreset.none,
        customDateRange: null,
      );
    } else {
      state = state.copyWith(datePreset: preset, customDateRange: customRange);
    }
  }

  void setCounterpartySuffixQuery(String? query) {
    if (query == null || query.isEmpty) {
      state = state.clearCounterparty();
    } else {
      state = state.copyWith(counterpartySuffixQuery: query);
    }
  }

  void toggleMemberPreset({required bool useAll}) {
    if (useAll) {
      state = state.copyWith(
        useAllMembers: true,
        selectedMemberUids: [],
        useAllWallets: true, // Reset wallets when members reset
        selectedWalletIds: [],
      );
    } else {
      List<String> memberUids = [];
      if (arg is MultiWalletTransactionsRouteData) {
        memberUids = (arg as MultiWalletTransactionsRouteData).wallets
            .map((e) => e.memberId)
            .toSet()
            .toList();
      }
      state = state.copyWith(
        useAllMembers: false,
        selectedMemberUids: memberUids,
        useAllWallets: true,
        selectedWalletIds: [],
      );
    }
  }

  void toggleMember(String memberUid) {
    final updated = List<String>.from(state.selectedMemberUids);
    if (!state.useAllMembers && updated.contains(memberUid)) {
      updated.remove(memberUid);
      if (updated.isEmpty) {
        toggleMemberPreset(useAll: true);
        return;
      }
    } else {
      if (state.useAllMembers) {
        updated.clear();
      }
      updated.add(memberUid);
    }
    state = state.copyWith(
      useAllMembers: false,
      selectedMemberUids: updated,
      useAllWallets: true, // Reset wallets when members change
      selectedWalletIds: [],
    );
  }

  void toggleWalletPreset({required bool useAll}) {
    if (useAll) {
      state = state.copyWith(useAllWallets: true, selectedWalletIds: []);
    } else {
      List<String> walletIds = [];
      if (arg is MultiWalletTransactionsRouteData) {
        walletIds = (arg as MultiWalletTransactionsRouteData).wallets
            .map((e) => e.walletId)
            .toList();
      }
      state = state.copyWith(
        useAllWallets: false,
        selectedWalletIds: walletIds,
      );
    }
  }

  void toggleWallet(String walletId) {
    final updated = List<String>.from(state.selectedWalletIds);
    if (!state.useAllWallets && updated.contains(walletId)) {
      updated.remove(walletId);
      if (updated.isEmpty) {
        toggleWalletPreset(useAll: true);
        return;
      }
    } else {
      if (state.useAllWallets) {
        updated.clear();
      }
      updated.add(walletId);
    }
    state = state.copyWith(useAllWallets: false, selectedWalletIds: updated);
  }

  void clearDatePreset() {
    state = state.copyWith(datePreset: DatePreset.none);
  }

  void selectAllMembers() {
    toggleMemberPreset(useAll: true);
  }

  void clearAllFilters() {
    state = const DraftFiltersState();
  }
}
