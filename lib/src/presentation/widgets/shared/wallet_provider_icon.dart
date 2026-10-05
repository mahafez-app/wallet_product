import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mahafez_core/mahafez_core.dart';

class WalletProviderIcon extends StatelessWidget {
  const WalletProviderIcon({
    super.key,
    required this.provider,
    required this.size,
    this.fallbackColor,
    this.assetPathResolver,
  });

  final WalletProvider provider;
  final double size;
  final Color? fallbackColor;
  final String? Function(WalletProvider provider)? assetPathResolver;

  static String? Function(WalletProvider provider)? globalAssetPathResolver;

  @override
  Widget build(BuildContext context) {
    final resolver = assetPathResolver ?? globalAssetPathResolver;
    final assetPath = resolver != null ? resolver(provider) : null;
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
                width: size,
                height: size,
                colorFilter: fallbackColor != null
                    ? ColorFilter.mode(fallbackColor!, BlendMode.srcIn)
                    : null,
              )
            : Image.asset(
                assetPath,
                width: size,
                height: size,
                color: fallbackColor,
                colorBlendMode: fallbackColor != null ? BlendMode.srcIn : null,
              ),
      ),
    );
  }
}
