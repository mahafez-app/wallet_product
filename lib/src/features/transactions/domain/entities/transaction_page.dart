import 'package:equatable/equatable.dart';

import 'transaction_entity.dart';

sealed class TransactionsPageCursor extends Equatable {
  const TransactionsPageCursor();
}

final class WalletTransactionsPageCursor extends TransactionsPageCursor {
  const WalletTransactionsPageCursor({
    required this.createdAt,
    required this.transactionId,
  });

  final DateTime createdAt;
  final String transactionId;

  @override
  List<Object?> get props => [createdAt, transactionId];
}

final class WorkspaceTransactionsPageCursor extends TransactionsPageCursor {
  const WorkspaceTransactionsPageCursor({required this.walletCursors});

  final Map<String, WalletTransactionsPageCursor> walletCursors;

  @override
  List<Object?> get props => [
    walletCursors.entries.toList()
      ..sort((left, right) => left.key.compareTo(right.key)),
  ];
}

final class TransactionPage extends Equatable {
  const TransactionPage({
    required this.transactions,
    required this.totalCount,
    this.nextCursor,
  });

  final List<TransactionEntity> transactions;
  final int totalCount;
  final TransactionsPageCursor? nextCursor;

  bool get hasMore => nextCursor != null;

  @override
  List<Object?> get props => [transactions, totalCount, nextCursor];
}
