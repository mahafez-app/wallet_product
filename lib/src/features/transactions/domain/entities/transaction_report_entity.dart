import 'package:equatable/equatable.dart';

final class TransactionReportEntity extends Equatable {
  const TransactionReportEntity({
    required this.totalIncome,
    required this.totalOutcome,
    required this.balanceChange,
    required this.transactionCount,
    required this.transactionsByDay,
    required this.receivedTransactionCount,
    required this.sentTransactionCount,
  });

  final double totalIncome;
  final double totalOutcome;
  final double balanceChange;
  final int transactionCount;
  final Map<DateTime, double> transactionsByDay;
  final int receivedTransactionCount;
  final int sentTransactionCount;

  @override
  List<Object?> get props => [
    totalIncome,
    totalOutcome,
    balanceChange,
    transactionCount,
    transactionsByDay,
    receivedTransactionCount,
    sentTransactionCount,
  ];
}
