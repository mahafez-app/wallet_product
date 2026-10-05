import 'package:flutter/material.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_design_system/mahafez_design_system.dart';

import '../../utils/provider_ext.dart';
import '../shared/provider_icon.dart';

class ProviderGrid extends StatelessWidget {
  const ProviderGrid({
    super.key,
    required this.selectedProviders,
    required this.allowedProviders,
    required this.onProviderToggled,
  });

  final Set<WalletProvider> selectedProviders;
  final Set<WalletProvider> allowedProviders;
  final ValueChanged<WalletProvider> onProviderToggled;

  @override
  Widget build(BuildContext context) {
    final providers = WalletProvider.values
        .where((provider) => provider != WalletProvider.unknown)
        .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: MahafezSpacing.sm.responsiveWidth,
        mainAxisSpacing: MahafezSpacing.sm.responsiveHeight,
        childAspectRatio: 1.7,
      ),
      itemCount: providers.length,
      itemBuilder: (context, index) {
        final provider = providers[index];
        return _ProviderCard(
          key: ValueKey('_ProviderCard_${provider.name}'),
          provider: provider,
          isEnabled: allowedProviders.contains(provider),
          isSelected: selectedProviders.contains(provider),
          onTap: () => onProviderToggled(provider),
        );
      },
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({
    super.key,
    required this.provider,
    required this.isEnabled,
    required this.isSelected,
    required this.onTap,
  });

  final WalletProvider provider;
  final bool isEnabled;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(12.responsiveRadius),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer.withAlpha(30)
                : !isEnabled
                ? theme.colorScheme.surfaceContainerLowest
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12.responsiveRadius),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : !isEnabled
                  ? theme.colorScheme.outlineVariant.withAlpha(120)
                  : theme.colorScheme.outlineVariant,
              width: isSelected ? 2.responsiveWidth : 1.responsiveWidth,
            ),
          ),
          child: Padding(
            padding: MahafezResponsive.allPadding(MahafezSpacing.sm),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: isEnabled ? 1 : 0.45,
                  child: ProviderIcon(
                    provider: provider,
                    size: 40.responsiveRadius,
                  ),
                ),
                MahafezSpacing.xs.verticalSpace,
                Text(
                  provider.displayName(context),
                  style: isSelected
                      ? theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        )
                      : theme.textTheme.bodyMedium?.copyWith(
                          color: isEnabled
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.outline,
                        ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
