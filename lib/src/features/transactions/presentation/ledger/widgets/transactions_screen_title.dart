import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import 'package:wallet_product/src/shared/utils/localization_extension.dart';
import 'package:wallet_product/src/shared/utils/phone_number_extension.dart';
import 'package:wallet_product/src/shared/utils/provider_ext.dart';
import '../navigation/transactions_route_data.dart';
import '../../../../../shared/widgets/provider_icon.dart';

class TransactionsScreenTitle extends StatelessWidget {
  const TransactionsScreenTitle({super.key, required this.routeData});

  final TransactionsRouteData routeData;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return switch (routeData) {
      WalletTransactionsRouteData(:final provider, :final phoneNumber) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProviderIcon(provider: provider, size: 32.responsiveRadius),
          MahafezSpacing.md.horizontalSpace,
          Flexible(
            child: _DoubleLineTitleText(
              title: provider.displayName(context),
              subtitle: phoneNumber.formattedEgyptianPhoneNumber,
            ),
          ),
        ],
      ),
      MultiWalletTransactionsRouteData(:final title) => _DoubleLineTitleText(
        title: title,
        subtitle: l10n.allTransactions,
      ),
    };
  }
}

class _DoubleLineTitleText extends StatelessWidget {
  const _DoubleLineTitleText({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        Text(
          subtitle,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.outline,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
