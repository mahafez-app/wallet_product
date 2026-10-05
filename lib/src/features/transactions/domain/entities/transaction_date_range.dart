import 'package:equatable/equatable.dart';

class TransactionDateRange extends Equatable {
  const TransactionDateRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  @override
  List<Object> get props => [start, end];
}
