import 'dart:convert';
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

abstract interface class DeletedTransactionLocalDataSource {
  Future<void> markDeleted(String transactionId);

  Future<bool> isDeleted(String transactionId);

  Future<void> remove(String transactionId);

  Future<void> pruneExpired();
}

final class DeletedTransactionLocalDataSourceImpl
    implements DeletedTransactionLocalDataSource {
  const DeletedTransactionLocalDataSourceImpl({required Box<String> box})
    : _box = box;

  final Box<String> _box;

  static const Duration _retention = Duration(days: 30);
  static const String _tag = 'DeletedTransactionLocalDataSource';

  @override
  Future<void> markDeleted(String transactionId) async {
    await pruneExpired();
    final payload = jsonEncode({'deletedAt': DateTime.now().toIso8601String()});
    await _box.put(transactionId, payload);
  }

  @override
  Future<bool> isDeleted(String transactionId) async {
    final raw = _box.get(transactionId);
    if (raw == null) return false;

    final deletedAt = _parseDeletedAt(raw, transactionId);
    if (deletedAt == null) return false;
    if (!_isExpired(deletedAt)) return true;

    await remove(transactionId);
    return false;
  }

  @override
  Future<void> remove(String transactionId) => _box.delete(transactionId);

  @override
  Future<void> pruneExpired() async {
    final expiredKeys = <String>[];

    for (final key in _box.keys) {
      if (key is! String) continue;

      final raw = _box.get(key);
      if (raw == null) {
        expiredKeys.add(key);
        continue;
      }

      final deletedAt = _parseDeletedAt(raw, key);
      if (deletedAt == null || _isExpired(deletedAt)) {
        expiredKeys.add(key);
      }
    }

    if (expiredKeys.isEmpty) return;
    await _box.deleteAll(expiredKeys);
  }

  DateTime? _parseDeletedAt(String raw, String transactionId) {
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final value = json['deletedAt'] as String?;
      return value == null ? null : DateTime.tryParse(value);
    } catch (error, stackTrace) {
      log(
        'Invalid tombstone payload for $transactionId. Removing entry.',
        name: _tag,
        error: error,
        stackTrace: stackTrace,
      );
      _box.delete(transactionId);
      return null;
    }
  }

  bool _isExpired(DateTime deletedAt) {
    return DateTime.now().difference(deletedAt) > _retention;
  }
}
