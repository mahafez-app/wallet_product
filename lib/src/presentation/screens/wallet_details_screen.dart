import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../domain/entities/wallet_details_entity.dart';
import '../../localization/wallet_localization.dart';
import '../providers/wallet_details_controller.dart';
import '../widgets/shared/wallet_provider_info.dart';
import '../widgets/wallet_details/wallet_balance_section.dart';

class WalletDetailsScreen extends StatelessWidget {
  const WalletDetailsScreen({
    super.key,
    required this.walletId,
    this.onReportsPressed,
    this.manualTransactionActionBuilder,
    this.syncSectionBuilder,
    this.recentTransactionsSectionBuilder,
  });

  final String walletId;
  final VoidCallback? onReportsPressed;
  final Widget Function(BuildContext context, String walletId)?
      manualTransactionActionBuilder;
  final Widget Function(BuildContext context, WalletDetailsEntity details)?
      syncSectionBuilder;
  final Widget Function(BuildContext context, WalletDetailsEntity details)?
      recentTransactionsSectionBuilder;

  @override
  Widget build(BuildContext context) {
    final l10n = context.walletL10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.walletDetails),
        centerTitle: true,
        actions: [
          if (onReportsPressed != null)
            IconButton(
              onPressed: onReportsPressed,
              icon: const Icon(Icons.bar_chart_rounded),
            ),
        ],
      ),
      body: SafeArea(
        child: _WalletDetailsBody(
          walletId: walletId,
          manualTransactionActionBuilder: manualTransactionActionBuilder,
          syncSectionBuilder: syncSectionBuilder,
          recentTransactionsSectionBuilder: recentTransactionsSectionBuilder,
        ),
      ),
    );
  }
}

class _WalletDetailsBody extends ConsumerWidget {
  const _WalletDetailsBody({
    required this.walletId,
    this.manualTransactionActionBuilder,
    this.syncSectionBuilder,
    this.recentTransactionsSectionBuilder,
  });

  final String walletId;
  final Widget Function(BuildContext context, String walletId)?
      manualTransactionActionBuilder;
  final Widget Function(BuildContext context, WalletDetailsEntity details)?
      syncSectionBuilder;
  final Widget Function(BuildContext context, WalletDetailsEntity details)?
      recentTransactionsSectionBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walletDetailsControllerProvider(walletId));

    return state.when(
      loading: () => const MahafezLoader(),
      error: (error, _) => MahafezErrorView(error: error),
      data: (details) => SingleChildScrollView(
        padding: MahafezSpacing.pagePadding,
        child: Column(
          children: [
            WalletBalanceSection(
              details: details,
              manualTransactionActionBuilder: manualTransactionActionBuilder,
            ),
            MahafezSpacing.md.verticalSpace,
            _WalletInfoSection(details: details),
            if (syncSectionBuilder != null) ...[
              MahafezSpacing.md.verticalSpace,
              syncSectionBuilder!(context, details),
            ],
            if (recentTransactionsSectionBuilder != null) ...[
              MahafezSpacing.md.verticalSpace,
              recentTransactionsSectionBuilder!(context, details),
            ],
          ],
        ),
      ),
    );
  }
}

class _WalletInfoSection extends StatelessWidget {
  const _WalletInfoSection({required this.details});

  final WalletDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    final wallet = details.wallet;
    final colors = context.mahafezColors;

    return Container(
      padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadiusDirectional.circular(20.responsiveRadius),
        border: Border.all(color: colors.cardBorder),
      ),
      child: WalletProviderInfo(
        provider: wallet.provider,
        phoneNumber: wallet.phoneNumber,
        borderRadius: 8,
      ),
    );
  }
}
