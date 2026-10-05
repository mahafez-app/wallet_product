import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../domain/entities/transaction_report_entity.dart';
import '../../domain/entities/transaction_report_filter.dart';
import '../../domain/usecases/get_transactions_report_usecase.dart';
import '../controllers/transaction_providers.dart';

import 'package:wallet_product/generated/wallet_localizations.dart';

final class WalletReportOption {
  const WalletReportOption({required this.id, required this.label});

  final String id;
  final String label;
}

/// Product-owned transaction report UI. The host supplies wallet IDs and
/// optional display labels, so this screen has no workspace dependency.
class WalletTransactionReportScreen extends ConsumerStatefulWidget {
  const WalletTransactionReportScreen({
    super.key,
    required this.walletIds,
    required this.title,
    this.walletOptions = const [],
  });

  final List<String> walletIds;
  final String title;
  final List<WalletReportOption> walletOptions;

  @override
  ConsumerState<WalletTransactionReportScreen> createState() =>
      _WalletTransactionReportScreenState();
}

class _WalletTransactionReportScreenState
    extends ConsumerState<WalletTransactionReportScreen> {
  TransactionReportFilter _filter = const TransactionReportFilter();
  late Future<TransactionReportEntity> _reportFuture;

  @override
  void initState() {
    super.initState();
    _reportFuture = _loadReport();
  }

  @override
  void didUpdateWidget(covariant WalletTransactionReportScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_sameIds(oldWidget.walletIds, widget.walletIds)) {
      _reportFuture = _loadReport();
    }
  }

  bool _sameIds(List<String> a, List<String> b) =>
      a.length == b.length &&
      List.generate(a.length, (i) => a[i] == b[i]).every((v) => v);

  Future<TransactionReportEntity> _loadReport() async {
    final now = DateTime.now();
    final DateTime start;
    final DateTime end;
    switch (_filter.period) {
      case TransactionReportPeriod.today:
        start = DateTime(now.year, now.month, now.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
      case TransactionReportPeriod.yesterday:
        final day = now.subtract(const Duration(days: 1));
        start = DateTime(day.year, day.month, day.day);
        end = DateTime(day.year, day.month, day.day, 23, 59, 59);
      case TransactionReportPeriod.lastWeek:
        final day = now.subtract(const Duration(days: 7));
        start = DateTime(day.year, day.month, day.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
      case TransactionReportPeriod.lastMonth:
        final day = now.subtract(const Duration(days: 30));
        start = DateTime(day.year, day.month, day.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
      case TransactionReportPeriod.customRange:
        final from =
            _filter.customStart ?? DateTime(now.year, now.month, now.day);
        final to = _filter.customEnd ?? from;
        start = DateTime(from.year, from.month, from.day);
        end = DateTime(to.year, to.month, to.day, 23, 59, 59);
    }

    final selectedIds = _filter.selectedWalletIds.isEmpty
        ? widget.walletIds
        : _filter.selectedWalletIds
              .where(widget.walletIds.contains)
              .toList(growable: false);
    final result = await ref.read(getTransactionsReportUseCaseProvider)(
      GetTransactionsReportParams(
        walletIds: selectedIds,
        startDate: start,
        endDate: end,
      ),
    );
    return result.fold((failure) => throw failure, (report) => report);
  }

  void _changeFilter(TransactionReportFilter filter) {
    setState(() {
      _filter = filter;
      _reportFuture = _loadReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WalletLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            _PeriodSelector(filter: _filter, onChanged: _changeFilter),
            if (widget.walletOptions.isNotEmpty)
              _WalletSelector(
                options: widget.walletOptions,
                filter: _filter,
                onChanged: _changeFilter,
              ),
            Expanded(
              child: FutureBuilder<TransactionReportEntity>(
                future: _reportFuture,
                builder: (context, snapshot) => switch (snapshot) {
                  AsyncSnapshot(connectionState: ConnectionState.waiting) =>
                    const Center(child: MahafezLoader()),
                  AsyncSnapshot(hasError: true, :final error) => Padding(
                    padding: MahafezSpacing.pagePadding,
                    child: MahafezErrorView(error: error!),
                  ),
                  AsyncSnapshot(hasData: true, :final data) => _ReportSummary(
                    report: data!,
                  ),
                  _ => Center(child: Text(l10n.transactions_emptyTitle)),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({required this.filter, required this.onChanged});
  final TransactionReportFilter filter;
  final ValueChanged<TransactionReportFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = WalletLocalizations.of(context)!;
    final labels = {
      TransactionReportPeriod.today: l10n.reportPeriodToday,
      TransactionReportPeriod.yesterday: l10n.reportPeriodYesterday,
      TransactionReportPeriod.lastWeek: l10n.reportPeriodWeek,
      TransactionReportPeriod.lastMonth: l10n.reportPeriodMonth,
      TransactionReportPeriod.customRange: l10n.reportPeriodCustom,
    };
    return Padding(
      padding: MahafezSpacing.pagePadding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: TransactionReportPeriod.values.map((period) {
            final selected = filter.period == period;
            return Padding(
              padding: EdgeInsetsDirectional.only(
                end: MahafezSpacing.sm.responsiveWidth,
              ),
              child: ChoiceChip(
                label: Text(labels[period]!),
                selected: selected,
                onSelected: (_) async {
                  if (period != TransactionReportPeriod.customRange) {
                    onChanged(filter.copyWith(period: period));
                    return;
                  }
                  final now = DateTime.now();
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: now,
                    initialDateRange:
                        filter.customStart == null || filter.customEnd == null
                        ? null
                        : DateTimeRange(
                            start: filter.customStart!,
                            end: filter.customEnd!,
                          ),
                  );
                  if (picked != null) {
                    onChanged(
                      filter.copyWith(
                        period: period,
                        customStart: picked.start,
                        customEnd: picked.end,
                      ),
                    );
                  }
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _WalletSelector extends StatelessWidget {
  const _WalletSelector({
    required this.options,
    required this.filter,
    required this.onChanged,
  });
  final List<WalletReportOption> options;
  final TransactionReportFilter filter;
  final ValueChanged<TransactionReportFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final allSelected = filter.selectedWalletIds.isEmpty;
    return Padding(
      padding: MahafezSpacing.pagePadding.copyWith(top: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterChip(
              label: Text(WalletLocalizations.of(context)!.reportAllWallets),
              selected: allSelected,
              onSelected: (_) =>
                  onChanged(filter.copyWith(selectedWalletIds: [])),
            ),
            ...options.map(
              (option) => Padding(
                padding: EdgeInsetsDirectional.only(
                  start: MahafezSpacing.sm.responsiveWidth,
                ),
                child: FilterChip(
                  label: Text(option.label),
                  selected: filter.selectedWalletIds.contains(option.id),
                  onSelected: (selected) {
                    final ids = [...filter.selectedWalletIds];
                    selected ? ids.add(option.id) : ids.remove(option.id);
                    onChanged(
                      filter.copyWith(
                        selectedWalletIds: ids.length == options.length
                            ? []
                            : ids,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportSummary extends StatelessWidget {
  const _ReportSummary({required this.report});
  final TransactionReportEntity report;

  @override
  Widget build(BuildContext context) {
    final l10n = WalletLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    String amount(double value) =>
        NumberFormat('#,##0.00', locale).format(value);
    final colors = context.mahafezColors;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: MahafezSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: MahafezResponsive.allPadding(MahafezSpacing.xl),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.responsiveRadius),
              gradient: LinearGradient(
                colors: [colors.statsGradientStart, colors.statsGradientEnd],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.reportBalance,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colors.statsOnGradient,
                  ),
                ),
                MahafezSpacing.xs.verticalSpace,
                Text(
                  '${report.balanceChange >= 0 ? '+' : '-'} ${amount(report.balanceChange.abs())} ${l10n.currency}',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: colors.statsOnGradient,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          MahafezSpacing.xl.verticalSpace,
          Text(
            l10n.reportPerformance,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          MahafezSpacing.md.verticalSpace,
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: MahafezSpacing.md.responsiveHeight,
            crossAxisSpacing: MahafezSpacing.md.responsiveWidth,
            childAspectRatio: 1.4,
            children: [
              _Metric(
                title: l10n.totalIn,
                value: '+ ${amount(report.totalIncome)}',
              ),
              _Metric(
                title: l10n.totalOut,
                value: '- ${amount(report.totalOutcome)}',
              ),
              _Metric(
                title: l10n.reportTransactionCount,
                value: '${report.transactionCount}',
              ),
              _Metric(
                title: l10n.reportDailyAverage,
                value: amount(
                  report.transactionCount == 0
                      ? 0
                      : report.balanceChange / report.transactionCount,
                ),
              ),
              _Metric(
                title: l10n.reportReceivedCount,
                value: '${report.receivedTransactionCount}',
              ),
              _Metric(
                title: l10n.reportSentCount,
                value: '${report.sentTransactionCount}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    padding: MahafezResponsive.allPadding(MahafezSpacing.md),
    decoration: BoxDecoration(
      color: context.mahafezColors.cardBackground,
      borderRadius: BorderRadius.circular(24.responsiveRadius),
      boxShadow: [
        BoxShadow(
          color: context.mahafezColors.cardShadow,
          blurRadius: 15.responsiveRadius,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: Theme.of(context).colorScheme.outline),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        MahafezSpacing.sm.verticalSpace,
        FittedBox(
          child: Text(
            value,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    ),
  );
}
