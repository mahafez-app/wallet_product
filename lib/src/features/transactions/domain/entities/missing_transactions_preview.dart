import 'package:equatable/equatable.dart';

import 'transaction_entity.dart';

final class MissingTransactionsPreview extends Equatable {
  const MissingTransactionsPreview({
    required this.transactions,
    this.fromDate,
  });

  final List<TransactionEntity> transactions;
  final DateTime? fromDate;

  int get count => transactions.length;

  @override
  List<Object?> get props => [transactions, fromDate];
}
