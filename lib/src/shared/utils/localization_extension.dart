import 'package:flutter/widgets.dart';

import '../../../generated/wallet_localizations.dart';

extension WalletLocalizationExtension on BuildContext {
  WalletLocalizations get l10n {
    final localizations = WalletLocalizations.of(this);
    if (localizations == null) {
      throw FlutterError(
        'WalletLocalizations.of(context) returned null. Ensure that '
        'WalletLocalizations.localizationsDelegates is included in MaterialApp.',
      );
    }
    return localizations;
  }
}
