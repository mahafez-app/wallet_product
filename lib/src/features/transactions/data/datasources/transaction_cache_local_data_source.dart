import 'dart:convert';
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/transaction_dto.dart';
import 'package:mahafez_core/mahafez_core.dart';
import '../models/transaction_page_dto.dart';

// ── Interface ─────────────────────────────────────────────────────────────────

abstract interface class TransactionCacheLocalDataSource {
  /// Returns the cached first page for [walletId], or null if absent / stale.
  Future<TransactionPageDto?> getFirstPage(String walletId);

  /// Persists [page] as the first-page cache entry for [walletId].
  ///
  /// Only call for first-page, no-filter fetches (the repository enforces this).
  Future<void> saveFirstPage(String walletId, TransactionPageDto page);

  /// Removes the cache entry for [walletId] (e.g. after a mutation).
  Future<void> clear(String walletId);
}

// ── Implementation ────────────────────────────────────────────────────────────

final class TransactionCacheLocalDataSourceImpl
    implements TransactionCacheLocalDataSource {
  const TransactionCacheLocalDataSourceImpl({required Box<String> box})
      : _box = box;

  final Box<String> _box;

  static const String _metaKeySuffix = '__meta';

  /// Cache entries older than this are ignored and overwritten on the next
  /// successful fetch. 24 h is safe because live-sync keeps in-memory state
  /// current; stale disk data is never used once the remote fetch completes.
  static const Duration _maxAge = Duration(hours: 24);

  @override
  Future<TransactionPageDto?> getFirstPage(String walletId) async {
    final metaRaw = _box.get(_metaKey(walletId));
    if (metaRaw == null) return null;

    final meta = jsonDecode(metaRaw) as Map<String, dynamic>;
    final cachedAt = DateTime.tryParse(meta['cachedAt'] as String? ?? '');
    if (cachedAt == null || DateTime.now().difference(cachedAt) > _maxAge) {
      await clear(walletId);
      return null;
    }

    final pageRaw = _box.get(walletId);
    if (pageRaw == null) return null;

    try {
      final json = jsonDecode(pageRaw) as Map<String, dynamic>;
      return _pageFromJson(json);
    } catch (e, st) {
      log(
        'TransactionCacheLocalDataSource: corrupt cache for $walletId — clearing.',
        name: 'Cache',
        error: e,
        stackTrace: st,
      );
      await clear(walletId);
      return null;
    }
  }

  @override
  Future<void> saveFirstPage(String walletId, TransactionPageDto page) async {
    final pageJson = jsonEncode(_pageToJson(page));
    final metaJson = jsonEncode({'cachedAt': DateTime.now().toIso8601String()});
    await _box.put(walletId, pageJson);
    await _box.put(_metaKey(walletId), metaJson);
  }

  @override
  Future<void> clear(String walletId) async {
    await _box.delete(walletId);
    await _box.delete(_metaKey(walletId));
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  String _metaKey(String walletId) => '$walletId$_metaKeySuffix';

  // We intentionally do NOT reuse TransactionDto.toFirestore() here — that
  // writes Firestore Timestamps. We serialise to plain JSON so Hive stores it
  // as a String without requiring type adapters or code generation.

  Map<String, dynamic> _pageToJson(TransactionPageDto page) => {
    'totalCount': page.totalCount,
    'transactions': page.transactions.map(_txToJson).toList(),
    // nextCursor is dropped intentionally — the cached page is always treated
    // as page 1. The controller will re-fetch page 2 from Firestore normally.
  };

  Map<String, dynamic> _txToJson(TransactionDto tx) => {
    'id': tx.id,
    'walletId': tx.walletId,
    'walletOwnerUid': tx.walletOwnerUid,
    'amount': tx.amount,
    'type': tx.type.name,
    'counterpartyNumber': tx.counterpartyNumber,
    'referenceNumber': tx.referenceNumber,
    'isPaid': tx.isPaid,
    'createdAt': tx.createdAt.toIso8601String(),
    'provider': tx.provider.toValue,
    'phoneNumber': tx.phoneNumber,
    'message': tx.message,
  };

  TransactionPageDto _pageFromJson(Map<String, dynamic> json) {
    final txList = (json['transactions'] as List)
        .cast<Map<String, dynamic>>()
        .map(_txFromJson)
        .toList();
    return TransactionPageDto(
      transactions: txList,
      totalCount: json['totalCount'] as int,
      nextCursor: null,
    );
  }

  TransactionDto _txFromJson(Map<String, dynamic> json) => TransactionDto(
    id: json['id'] as String,
    walletId: json['walletId'] as String,
    walletOwnerUid: json['walletOwnerUid'] as String,
    amount: (json['amount'] as num).toDouble(),
    type: TransactionType.values.byName(json['type'] as String),
    counterpartyNumber: json['counterpartyNumber'] as String?,
    referenceNumber: json['referenceNumber'] as String?,
    isPaid: json['isPaid'] as bool?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    provider: WalletProvider.fromString(json['provider'] as String),
    phoneNumber: json['phoneNumber'] as String,
    message: json['message'] as String?,
  );
}
