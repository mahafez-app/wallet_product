/// In-memory, TTL-based cache for wallet metadata.
final class WalletMetaCache {
  WalletMetaCache({this._ttl = const Duration(minutes: 10)});

  final Duration _ttl;
  final Map<String, _WalletMetaEntry> _store = {};

  WalletMeta? get(String walletId) {
    final entry = _store[walletId];
    if (entry == null || entry.isExpired) {
      _store.remove(walletId);
      return null;
    }
    return entry.meta;
  }

  void put(String walletId, WalletMeta meta) {
    _store[walletId] = _WalletMetaEntry(
      meta: meta,
      expiresAt: DateTime.now().add(_ttl),
    );
  }

  void invalidate(String walletId) => _store.remove(walletId);

  void clear() => _store.clear();
}

final class WalletMeta {
  const WalletMeta({
    required this.provider,
    required this.phoneNumber,
    required this.ownerUid,
  });

  final String provider;
  final String phoneNumber;
  final String ownerUid;
}

final class _WalletMetaEntry {
  _WalletMetaEntry({required this.meta, required this.expiresAt});

  final WalletMeta meta;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
