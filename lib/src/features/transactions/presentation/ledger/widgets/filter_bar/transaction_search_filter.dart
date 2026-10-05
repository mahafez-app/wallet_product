import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wallet_product/src/shared/utils/localization_extension.dart';
import '../../navigation/transactions_route_data.dart';
import '../../providers/draft_filters_controller.dart';

class TransactionSearchFilter extends ConsumerStatefulWidget {
  const TransactionSearchFilter({super.key, required this.routeData});

  final TransactionsRouteData routeData;

  @override
  ConsumerState<TransactionSearchFilter> createState() =>
      _TransactionSearchFilterState();
}

class _TransactionSearchFilterState
    extends ConsumerState<TransactionSearchFilter> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final initialValue = ref
        .read(draftFiltersControllerProvider(widget.routeData))
        .counterpartySuffixQuery;
    _controller = TextEditingController(text: initialValue ?? '');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(
      draftFiltersControllerProvider(
        widget.routeData,
      ).select((state) => state.counterpartySuffixQuery),
      (_, next) {
        final resolvedValue = next ?? '';
        if (_controller.text == resolvedValue) {
          return;
        }
        _controller.value = _controller.value.copyWith(
          text: resolvedValue,
          selection: TextSelection.collapsed(offset: resolvedValue.length),
        );
      },
    );
    final theme = Theme.of(context);
    final hasQuery = _controller.text.isNotEmpty;

    return Padding(
      padding: MahafezResponsive.symmetricPadding(
        horizontal: MahafezSpacing.lg,
        vertical: MahafezSpacing.sm,
      ),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: _onChanged,
        decoration: InputDecoration(
          hintText: context.l10n.transactions_searchHint,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: hasQuery
              ? IconButton(
                  onPressed: _clear,
                  icon: const Icon(Icons.close_rounded),
                )
              : null,
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerLow,
        ),
      ),
    );
  }

  void _clear() {
    _controller.clear();
    _debounce?.cancel();
    ref
        .read(draftFiltersControllerProvider(widget.routeData).notifier)
        .setCounterpartySuffixQuery('');
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    final notifier = ref.read(
      draftFiltersControllerProvider(widget.routeData).notifier,
    );
    if (value.isEmpty) {
      notifier.setCounterpartySuffixQuery('');
      return;
    }
    if (value.length < 2) {
      notifier.setCounterpartySuffixQuery('');
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () {
      notifier.setCounterpartySuffixQuery(value);
    });
  }
}
