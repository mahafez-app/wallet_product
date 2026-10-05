import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mahafez_core/mahafez_core.dart';

import '../constants/wallet_assets.dart';

class ProviderIcon extends StatelessWidget {
  const ProviderIcon({
    super.key,
    required this.provider,
    required this.size,
    this.fallbackColor,
  });

  final WalletProvider provider;
  final double size;
  final Color? fallbackColor;

  static String? _resolveAssetPath(WalletProvider provider) => switch (provider) {
    WalletProvider.vodafoneCash => WalletAssets.iconVodafone,
    WalletProvider.orangeMoney => WalletAssets.iconOrange,
    WalletProvider.etisalatCash => WalletAssets.iconEtisalat,
    WalletProvider.wePay => WalletAssets.iconWe,
    WalletProvider.instaPay => WalletAssets.iconInstaPay,
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
                package: WalletAssets.packageName,
                width: size,
                height: size,
                colorFilter: fallbackColor != null
                    ? ColorFilter.mode(fallbackColor!, BlendMode.srcIn)
                    : null,
              )
            : Image.asset(
                assetPath,
                package: WalletAssets.packageName,
                width: size,
                height: size,
                color: fallbackColor,
                colorBlendMode: fallbackColor != null ? BlendMode.srcIn : null,
              ),
      ),
    );
  }
}
