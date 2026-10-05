import 'package:equatable/equatable.dart';

enum TransactionReportPeriod {
  today,
  yesterday,
  lastWeek,
  lastMonth,
  customRange,
}

final class TransactionReportFilter extends Equatable {
  const TransactionReportFilter({
    this.period = TransactionReportPeriod.today,
    this.customStart,
    this.customEnd,
    this.selectedWalletIds = const [],
  });

  final TransactionReportPeriod period;
  final DateTime? customStart;
  final DateTime? customEnd;
  final List<String> selectedWalletIds;

  TransactionReportFilter copyWith({
    TransactionReportPeriod? period,
    DateTime? customStart,
    DateTime? customEnd,
    List<String>? selectedWalletIds,
  }) => TransactionReportFilter(
    period: period ?? this.period,
    customStart: customStart ?? this.customStart,
    customEnd: customEnd ?? this.customEnd,
    selectedWalletIds: selectedWalletIds ?? this.selectedWalletIds,
  );

  @override
  List<Object?> get props => [
    period,
    customStart,
    customEnd,
    selectedWalletIds,
  ];
}
