import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mahafez_core/mahafez_core.dart';

class ProviderIcon extends StatelessWidget {
  const ProviderIcon({
    super.key,
    required this.provider,
    required this.size,
    this.fallbackColor,
  });

  static const String _packageName = 'mahafez_wallet_product';

  final WalletProvider provider;
  final double size;
  final Color? fallbackColor;

  static String? _resolveAssetPath(WalletProvider provider) => switch (provider) {
    WalletProvider.vodafoneCash => 'assets/icons/vodafone.svg',
    WalletProvider.orangeMoney => 'assets/icons/orange.svg',
    WalletProvider.etisalatCash => 'assets/icons/etisalat.svg',
    WalletProvider.wePay => 'assets/icons/we.png',
    WalletProvider.instaPay => 'assets/icons/instapay.svg',
    WalletProvider.unknown => null,
  };

  @override
  Widget build(BuildContext context) {
    final assetPath = _resolveAssetPath(provider);
    final isSvg = assetPath?.toLowerCase().endsWith('.svg') ?? false;

    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: assetPath == null
            ? Icon(
                Icons.account_balance_wallet_outlined,
                size: size,
                color: fallbackColor,
              )
            : isSvg
            ? SvgPicture.asset(
                assetPath,
                package: _packageName,
                width: size,
                height: size,
                colorFilter: fallbackColor != null
                    ? ColorFilter.mode(fallbackColor!, BlendMode.srcIn)
                    : null,
              )
            : Image.asset(
                assetPath,
                package: _packageName,
                width: size,
                height: size,
                color: fallbackColor,
                colorBlendMode: fallbackColor != null ? BlendMode.srcIn : null,
              ),
      ),
    );
  }
}
