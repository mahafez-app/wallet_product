import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transaction_dto.dart';
import '../../../wallets/data/models/wallet_dto.dart';
import '../../domain/entities/transaction_entity.dart';
import 'package:mahafez_core/mahafez_core.dart';
import '../../domain/entities/transaction_date_range.dart';
import '../../domain/entities/transaction_page.dart';
import '../../domain/entities/transaction_paid_status_filter.dart';
import '../models/note_dto.dart';
import '../models/transaction_history_entry_dto.dart';
import '../models/transaction_page_dto.dart';
import 'transaction_firestore_support.dart';

abstract interface class WalletTransactionRemoteDataSource {
  Future<TransactionPageDto> getWalletTransactions({
    required String walletId,
    TransactionType? type,
    TransactionPaidStatusFilter paidStatusFilter =
        TransactionPaidStatusFilter.all,
    String? counterpartySuffixQuery,
    TransactionDateRange? dateRange,
    int limit = 20,
    WalletTransactionsPageCursor? cursor,
  });

  Future<void> markAsPaid({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
  });

  Future<void> markAsUnpaid({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
  });

  Future<void> saveTransaction(TransactionEntity transaction);

  Future<DateTime?> getLatestTransactionDate(String walletId);

  Future<List<TransactionDto>> getTransactionsSince({
    required String walletId,
    required DateTime fromDate,
  });

  Future<void> deleteTransaction({
    required String walletId,
    required String transactionId,
    required String userId,
  });

  Future<void> addNote({
    required String walletId,
    required String transactionId,
    required String text,
    required String userId,
    required String userName,
  });

  Future<void> editNote({
    required String walletId,
    required String transactionId,
    required String noteId,
    required String text,
  });

  Future<void> deleteNote({
    required String walletId,
    required String transactionId,
    required String noteId,
  });

  Stream<List<NoteDto>> getNotes({
    required String walletId,
    required String transactionId,
  });

  Stream<List<TransactionHistoryEntryDto>> getTransactionHistory({
    required String walletId,
    required String transactionId,
  });
}

final class WalletTransactionRemoteDataSourceImpl
    implements WalletTransactionRemoteDataSource {
  const WalletTransactionRemoteDataSourceImpl({
    required TransactionFirestoreSupport support,
  }) : _support = support;

  final TransactionFirestoreSupport _support;

  @override
  Future<TransactionPageDto> getWalletTransactions({
    required String walletId,
    TransactionType? type,
    TransactionPaidStatusFilter paidStatusFilter =
        TransactionPaidStatusFilter.all,
    String? counterpartySuffixQuery,
    TransactionDateRange? dateRange,
    int limit = 20,
    WalletTransactionsPageCursor? cursor,
  }) async {
    final meta = await _support.walletMeta(walletId);
    final countQuery = _support.applyFilters(
      _support.txCollection(walletId),
      type: type,
      paidStatusFilter: paidStatusFilter,
      counterpartySuffixQuery: counterpartySuffixQuery,
      dateRange: dateRange,
    );
    final countSnapshot = await countQuery.count().get();
    final total = countSnapshot.count ?? 0;

    var dataQuery = _support
        .applyFilters(
          _support.walletTransactionsQuery(walletId),
          type: type,
          paidStatusFilter: paidStatusFilter,
          counterpartySuffixQuery: counterpartySuffixQuery,
          dateRange: dateRange,
        )
        .limit(limit);

    if (cursor != null) {
      dataQuery = dataQuery.startAfter([
        Timestamp.fromDate(cursor.createdAt),
        cursor.transactionId,
      ]);
    }

    final snapshot = await dataQuery.get();
    final docs = snapshot.docs;
    final transactions = docs
        .map(
          (doc) => TransactionDto.fromFirestore(
            doc,
            meta.provider,
            meta.phoneNumber,
            walletId,
            meta.ownerUid,
          ),
        )
        .toList();

    return TransactionPageDto(
      transactions: transactions,
      totalCount: total,
      nextCursor: docs.length == limit
          ? _support.toWalletCursor(docs.last)
          : null,
    );
  }

  @override
  Future<void> markAsPaid({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
  }) => _updatePaidStatus(
    walletId: walletId,
    transactionId: transactionId,
    userId: userId,
    userName: userName,
    isPaid: true,
  );

  @override
  Future<void> markAsUnpaid({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
  }) => _updatePaidStatus(
    walletId: walletId,
    transactionId: transactionId,
    userId: userId,
    userName: userName,
    isPaid: false,
  );

  Future<void> _updatePaidStatus({
    required String walletId,
    required String transactionId,
    required String userId,
    required String userName,
    required bool isPaid,
  }) async {
    final txRef = _support.txCollection(walletId).doc(transactionId);
    final historyRef = txRef.collection('history').doc();
    final batch = txRef.firestore.batch();

    batch.update(txRef, {'isPaid': isPaid});
    batch.set(historyRef, {
      'isPaid': isPaid,
      'actorUid': userId,
      'actorName': userName,
      'occurredAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    final txRef = _support
        .txCollection(transaction.walletId)
        .doc(transaction.id);

    // Short-circuit if transaction already exists to avoid duplicate balance increments
    final txSnapshot = await txRef.get();
    if (txSnapshot.exists) {
      log(
        'Transaction ${transaction.id} already exists. Skipping save.',
        name: 'WalletTransactionRemoteDataSource',
      );
      throw const ValidationFailure(
        code: 'transaction-already-exists',
        technicalMessage: 'Transaction already exists.',
      );
    }

    final walletRef = _support.walletDocument(transaction.walletId);
    final walletSnapshot = await walletRef.get();
    if (!walletSnapshot.exists) return;

    final wallet = WalletDto.fromFirestore(walletSnapshot);
    final isMostRecent =
        transaction.createdAt.isAfter(wallet.lastBalanceAt) ||
        transaction.createdAt.isAtSameMomentAs(wallet.lastBalanceAt);

    final isAfterStatsReset =
        wallet.statsResetAt == null ||
        transaction.createdAt.isAfter(wallet.statsResetAt!);

    final dto = TransactionDto.fromEntity(transaction);
    final isReceive = transaction.type == TransactionType.receive;
    final amount = transaction.amount;

    final batch = txRef.firestore.batch();
    batch.set(txRef, dto.toFirestore());

    final walletUpdate = <String, dynamic>{};

    if (isAfterStatsReset) {
      walletUpdate['totalReceived'] = FieldValue.increment(
        isReceive ? amount : 0,
      );
      walletUpdate['totalSent'] = FieldValue.increment(isReceive ? 0 : amount);
    }

    if (isMostRecent) {
      walletUpdate['lastBalanceAt'] = Timestamp.fromDate(transaction.createdAt);
      if (transaction.statusBalance != null) {
        walletUpdate['currentBalance'] = transaction.statusBalance;
      } else {
        walletUpdate['currentBalance'] = FieldValue.increment(
          isReceive ? amount : -amount,
        );
      }
    }

    if (walletUpdate.isNotEmpty) {
      batch.update(walletRef, walletUpdate);
    }

    await batch.commit();
  }

  @override
  Future<DateTime?> getLatestTransactionDate(String walletId) async {
    final snapshot = await _support
        .walletTransactionsQuery(walletId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final data = snapshot.docs.first.data();
    final createdAt = data['createdAt'] as Timestamp?;
    return createdAt?.toDate();
  }

  @override
  Future<List<TransactionDto>> getTransactionsSince({
    required String walletId,
    required DateTime fromDate,
  }) async {
    final meta = await _support.walletMeta(walletId);
    final snapshot = await _support
        .txCollection(walletId)
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(fromDate))
        .orderBy('createdAt', descending: false)
        .get();

    return snapshot.docs
        .map(
          (doc) => TransactionDto.fromFirestore(
            doc,
            meta.provider,
            meta.phoneNumber,
            walletId,
            meta.ownerUid,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> deleteTransaction({
    required String walletId,
    required String transactionId,
    required String userId,
  }) async {
    final meta = await _support.walletMeta(walletId);
    if (meta.ownerUid != userId) {
      throw const PermissionFailure(
        technicalMessage: 'Only the wallet owner can delete transactions.',
      );
    }

    final walletRef = _support.walletDocument(walletId);
    final txRef = _support.txCollection(walletId).doc(transactionId);
    final txSnapshot = await txRef.get();
    if (!txSnapshot.exists) {
      throw const ValidationFailure(
        code: 'transaction-not-found',
        technicalMessage: 'Transaction does not exist.',
      );
    }

    final transaction = TransactionDto.fromFirestore(
      txSnapshot,
      meta.provider,
      meta.phoneNumber,
      walletId,
      meta.ownerUid,
    );
    final notesSnapshot = await txRef.collection('notes').get();
    final historySnapshot = await txRef.collection('history').get();

    final batch = txRef.firestore.batch();
    for (final noteDoc in notesSnapshot.docs) {
      batch.delete(noteDoc.reference);
    }
    for (final historyDoc in historySnapshot.docs) {
      batch.delete(historyDoc.reference);
    }
    batch.delete(txRef);

    final amount = transaction.amount;
    final isReceive = transaction.type == TransactionType.receive;
    batch.update(walletRef, {
      'currentBalance': FieldValue.increment(isReceive ? -amount : amount),
      'totalReceived': FieldValue.increment(isReceive ? -amount : 0),
      'totalSent': FieldValue.increment(isReceive ? 0 : -amount),
    });
    await batch.commit();

    await _syncWalletLastBalanceAt(walletRef: walletRef, walletId: walletId);
  }

  @override
  Future<void> addNote({
    required String walletId,
    required String transactionId,
    required String text,
    required String userId,
    required String userName,
  }) async {
    final noteRef = _support
        .txCollection(walletId)
        .doc(transactionId)
        .collection('notes')
        .doc();
    await noteRef.set({
      'text': text,
      'authorUid': userId,
      'authorName': userName,
      'createdAt': FieldValue.serverTimestamp(),
      'editedAt': null,
    });
  }

  @override
  Future<void> editNote({
    required String walletId,
    required String transactionId,
    required String noteId,
    required String text,
  }) async {
    await _support
        .txCollection(walletId)
        .doc(transactionId)
        .collection('notes')
        .doc(noteId)
        .update({'text': text, 'editedAt': FieldValue.serverTimestamp()});
  }

  @override
  Future<void> deleteNote({
    required String walletId,
    required String transactionId,
    required String noteId,
  }) async {
    await _support
        .txCollection(walletId)
        .doc(transactionId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }

  @override
  Stream<List<NoteDto>> getNotes({
    required String walletId,
    required String transactionId,
  }) {
    return _support
        .txCollection(walletId)
        .doc(transactionId)
        .collection('notes')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(NoteDto.fromFirestore).toList());
  }

  @override
  Stream<List<TransactionHistoryEntryDto>> getTransactionHistory({
    required String walletId,
    required String transactionId,
  }) {
    return _support
        .txCollection(walletId)
        .doc(transactionId)
        .collection('history')
        .orderBy('occurredAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(TransactionHistoryEntryDto.fromFirestore)
              .toList(),
        );
  }

  Future<void> _syncWalletLastBalanceAt({
    required DocumentReference<Map<String, dynamic>> walletRef,
    required String walletId,
  }) async {
    final latestTransactionSnapshot = await _support
        .walletTransactionsQuery(walletId)
        .limit(1)
        .get();
    final walletSnapshot = await walletRef.get();
    final wallet = WalletDto.fromFirestore(walletSnapshot);
    final latestCreatedAt = latestTransactionSnapshot.docs.isEmpty
        ? wallet.createdAt
        : _support
              .toWalletCursor(latestTransactionSnapshot.docs.first)
              .createdAt;

    await walletRef.update({
      'lastBalanceAt': Timestamp.fromDate(latestCreatedAt),
    });
  }
}
