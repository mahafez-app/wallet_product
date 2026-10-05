import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../domain/entities/wallet_entity.dart';
import '../providers/wallet_details_controller.dart';
import '../utils/localization_extension.dart';
import '../widgets/details/balance_section.dart';
import '../widgets/shared/provider_info.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
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
  final Widget Function(BuildContext context, WalletEntity wallet)?
      syncSectionBuilder;
  final Widget Function(BuildContext context, WalletEntity wallet)?
      recentTransactionsSectionBuilder;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
        child: _DetailsBody(
          walletId: walletId,
          manualTransactionActionBuilder: manualTransactionActionBuilder,
          syncSectionBuilder: syncSectionBuilder,
          recentTransactionsSectionBuilder: recentTransactionsSectionBuilder,
        ),
      ),
    );
  }
}

class _DetailsBody extends ConsumerWidget {
  const _DetailsBody({
    required this.walletId,
    this.manualTransactionActionBuilder,
    this.syncSectionBuilder,
    this.recentTransactionsSectionBuilder,
  });

  final String walletId;
  final Widget Function(BuildContext context, String walletId)?
      manualTransactionActionBuilder;
  final Widget Function(BuildContext context, WalletEntity wallet)?
      syncSectionBuilder;
  final Widget Function(BuildContext context, WalletEntity wallet)?
      recentTransactionsSectionBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walletDetailsControllerProvider(walletId));

    return state.when(
      loading: () => const MahafezLoader(),
      error: (error, _) => MahafezErrorView(error: error),
      data: (wallet) => SingleChildScrollView(
        padding: MahafezSpacing.pagePadding,
        child: Column(
          children: [
            BalanceSection(
              wallet: wallet,
              manualTransactionActionBuilder: manualTransactionActionBuilder,
            ),
            MahafezSpacing.md.verticalSpace,
            _InfoSection(wallet: wallet),
            if (syncSectionBuilder != null) ...[
              MahafezSpacing.md.verticalSpace,
              syncSectionBuilder!(context, wallet),
            ],
            if (recentTransactionsSectionBuilder != null) ...[
              MahafezSpacing.md.verticalSpace,
              recentTransactionsSectionBuilder!(context, wallet),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.wallet});

  final WalletEntity wallet;

  @override
  Widget build(BuildContext context) {
    final colors = context.mahafezColors;

    return Container(
      padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadiusDirectional.circular(20.responsiveRadius),
        border: Border.all(color: colors.cardBorder),
      ),
      child: ProviderInfo(
        provider: wallet.provider,
        phoneNumber: wallet.phoneNumber,
        borderRadius: 8,
      ),
    );
  }
}
