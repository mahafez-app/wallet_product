import 'package:flutter_test/flutter_test.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_wallet_product/mahafez_wallet_product.dart';

void main() {
  group('WalletEntity', () {
    test('instantiates correctly and implements SmsWalletCandidate', () {
      final testDate = DateTime.fromMillisecondsSinceEpoch(1000000);
      final entity = WalletEntity(
        id: 'wallet-1',
        phoneNumber: '01012345678',
        provider: WalletProvider.vodafoneCash,
        deviceId: 'device-1',
        ownerUid: 'user-1',
        currentBalance: 1500.0,
        totalReceived: 2000.0,
        totalSent: 500.0,
        lastBalanceAt: testDate,
        createdAt: testDate,
      );

      expect(entity.id, 'wallet-1');
      expect(entity.phoneNumber, '01012345678');
      expect(entity.provider, WalletProvider.vodafoneCash);
      expect(entity.currentBalance, 1500.0);
    });

    test('WalletEntity calculates suggestedBalance correctly', () {
      final testDate = DateTime.fromMillisecondsSinceEpoch(1000000);
      final entityWithLatest = WalletEntity(
        id: 'wallet-1',
        phoneNumber: '01012345678',
        provider: WalletProvider.vodafoneCash,
        deviceId: 'device-1',
        ownerUid: 'user-1',
        currentBalance: 1000.0,
        totalReceived: 0.0,
        totalSent: 0.0,
        lastBalanceAt: testDate,
        createdAt: testDate,
        latestActivityBalance: 1200.0,
      );
      expect(entityWithLatest.suggestedBalance, 1200.0);

      final entityWithoutLatest = entityWithLatest.copyWith(
        latestActivityBalance: null,
      );
      expect(entityWithoutLatest.suggestedBalance, 1000.0);
    });
  });

  group('WalletMetaCache', () {
    test('stores, retrieves, and invalidates cache entries', () {
      final cache = WalletMetaCache();
      const meta = WalletMeta(
        provider: 'vodafoneCash',
        phoneNumber: '01012345678',
        ownerUid: 'user-1',
      );

      cache.put('wallet-1', meta);
      expect(cache.get('wallet-1'), equals(meta));

      cache.invalidate('wallet-1');
      expect(cache.get('wallet-1'), isNull);
    });
  });
}
