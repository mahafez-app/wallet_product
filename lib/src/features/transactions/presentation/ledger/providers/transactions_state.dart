import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:mahafez_core/mahafez_core.dart';

import '../../../domain/entities/transaction_date_range.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../../domain/entities/transaction_page.dart';
import '../../../domain/entities/transaction_paid_status_filter.dart';

enum TransactionTypeFilter { all, receive, send }

enum DatePreset { none, today, yesterday, week, month, custom }

final class TransactionsState extends Equatable {
  const TransactionsState({
    this.transactions = const <TransactionEntity>[],
    this.typeFilter = TransactionTypeFilter.all,
    this.paidStatusFilter = TransactionPaidStatusFilter.all,
    this.datePreset = DatePreset.none,
    this.customDateRange,
    this.counterpartySuffixQuery,
    this.useAllMembers = true,
    this.selectedMemberUids = const <String>[],
    this.useAllWallets = true,
    this.selectedWalletIds = const <String>[],
    this.totalCount = 0,
    this.nextCursor,
    this.isLoadingInitial = true,
    this.isLoadingMore = false,
    this.error,
  });

  final List<TransactionEntity> transactions;
  final TransactionTypeFilter typeFilter;
  final TransactionPaidStatusFilter paidStatusFilter;
  final DatePreset datePreset;
  final DateTimeRange? customDateRange;
  final String? counterpartySuffixQuery;
  final bool useAllMembers;
  final List<String> selectedMemberUids;
  final bool useAllWallets;
  final List<String> selectedWalletIds;
  final int totalCount;
  final TransactionsPageCursor? nextCursor;
  final bool isLoadingInitial;
  final bool isLoadingMore;

  final Failure? error;

  bool get hasMore => nextCursor != null;
  bool get hasActiveFilter =>
      typeFilter != TransactionTypeFilter.all ||
      paidStatusFilter != TransactionPaidStatusFilter.all ||
      datePreset != DatePreset.none ||
      (counterpartySuffixQuery?.isNotEmpty ?? false) ||
      !useAllMembers ||
      !useAllWallets;

  int get activeFilterCount {
    var count = 0;
    if (typeFilter != TransactionTypeFilter.all) count++;
    if (paidStatusFilter != TransactionPaidStatusFilter.all) count++;
    if (datePreset != DatePreset.none) count++;
    if (counterpartySuffixQuery?.isNotEmpty ?? false) count++;
    if (!useAllMembers) count++;
    if (!useAllWallets) count++;
    return count;
  }

  TransactionType? get resolvedType => switch (typeFilter) {
    TransactionTypeFilter.all => null,
    TransactionTypeFilter.receive => TransactionType.receive,
    TransactionTypeFilter.send => TransactionType.send,
  };

  Map<DateTime, List<TransactionEntity>> get groupedTransactions {
    final map = <DateTime, List<TransactionEntity>>{};
    for (final transaction in transactions) {
      final day = DateTime(
        transaction.createdAt.year,
        transaction.createdAt.month,
        transaction.createdAt.day,
      );
      (map[day] ??= <TransactionEntity>[]).add(transaction);
    }
    return map;
  }

  TransactionDateRange? get resolvedDateRange {
    final now = DateTime.now();
    return switch (datePreset) {
      DatePreset.none => null,
      DatePreset.today => TransactionDateRange(
        start: DateTime(now.year, now.month, now.day),
        end: now,
      ),
      DatePreset.yesterday => TransactionDateRange(
        start: DateTime(now.year, now.month, now.day - 1),
        end: DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(const Duration(microseconds: 1)),
      ),
      DatePreset.week => TransactionDateRange(
        start: now.subtract(const Duration(days: 7)),
        end: now,
      ),
      DatePreset.month => TransactionDateRange(
        start: now.subtract(const Duration(days: 30)),
        end: now,
      ),
      DatePreset.custom =>
        customDateRange == null
            ? null
            : TransactionDateRange(
                start: customDateRange!.start,
                end: customDateRange!.end,
              ),
    };
  }

  TransactionsState copyWith({
    List<TransactionEntity>? transactions,
    TransactionTypeFilter? typeFilter,
    TransactionPaidStatusFilter? paidStatusFilter,
    DatePreset? datePreset,
    Object? customDateRange = _sentinel,
    Object? counterpartySuffixQuery = _sentinel,
    bool? useAllMembers,
    Object? selectedMemberUids = _sentinel,
    bool? useAllWallets,
    Object? selectedWalletIds = _sentinel,
    int? totalCount,
    Object? nextCursor = _sentinel,
    bool? isLoadingInitial,
    bool? isLoadingMore,
    Object? error = _sentinel,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      typeFilter: typeFilter ?? this.typeFilter,
      paidStatusFilter: paidStatusFilter ?? this.paidStatusFilter,
      datePreset: datePreset ?? this.datePreset,
      customDateRange: identical(customDateRange, _sentinel)
          ? this.customDateRange
          : customDateRange as DateTimeRange?,
      counterpartySuffixQuery: identical(counterpartySuffixQuery, _sentinel)
          ? this.counterpartySuffixQuery
          : counterpartySuffixQuery as String?,
      useAllMembers: useAllMembers ?? this.useAllMembers,
      selectedMemberUids: identical(selectedMemberUids, _sentinel)
          ? this.selectedMemberUids
          : List<String>.of(
              (selectedMemberUids as Iterable<Object?>).cast<String>(),
            ),
      useAllWallets: useAllWallets ?? this.useAllWallets,
      selectedWalletIds: identical(selectedWalletIds, _sentinel)
          ? this.selectedWalletIds
          : List<String>.of(
              (selectedWalletIds as Iterable<Object?>).cast<String>(),
            ),
      totalCount: totalCount ?? this.totalCount,
      nextCursor: identical(nextCursor, _sentinel)
          ? this.nextCursor
          : nextCursor as TransactionsPageCursor?,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: identical(error, _sentinel) ? this.error : error as Failure?,
    );
  }

  bool matches(TransactionEntity transaction) {
    final type = resolvedType;
    if (type != null && transaction.type != type) return false;

    if (paidStatusFilter != TransactionPaidStatusFilter.all) {
      if (transaction.type != TransactionType.receive) return false;
      final isPaid = transaction.isPaid ?? false;
      if (paidStatusFilter == TransactionPaidStatusFilter.paid && !isPaid) {
        return false;
      }
      if (paidStatusFilter == TransactionPaidStatusFilter.unpaid && isPaid) {
        return false;
      }
    }

    final range = resolvedDateRange;
    if (range != null) {
      if (transaction.createdAt.isBefore(range.start) ||
          transaction.createdAt.isAfter(range.end)) {
        return false;
      }
    }

    if (counterpartySuffixQuery != null) {
      final number = transaction.counterpartyNumber ?? '';
      if (!number.endsWith(counterpartySuffixQuery!)) return false;
    }

    if (!useAllMembers &&
        !selectedMemberUids.contains(transaction.walletOwnerUid)) {
      return false;
    }

    if (!useAllWallets && !selectedWalletIds.contains(transaction.walletId)) {
      return false;
    }

    return true;
  }

  @override
  List<Object?> get props => [
    transactions,
    typeFilter,
    paidStatusFilter,
    datePreset,
    customDateRange,
    counterpartySuffixQuery,
    useAllMembers,
    selectedMemberUids,
    useAllWallets,
    selectedWalletIds,
    totalCount,
    nextCursor,
    isLoadingInitial,
    isLoadingMore,
    error,
  ];
}

const Object _sentinel = Object();
