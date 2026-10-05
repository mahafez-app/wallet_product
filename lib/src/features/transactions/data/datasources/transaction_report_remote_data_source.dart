import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahafez_core/mahafez_core.dart';

import '../../domain/entities/transaction_report_entity.dart';

final class TransactionReportRemoteDataSource {
  const TransactionReportRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<TransactionReportEntity> getReport({
    required List<String> walletIds,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (walletIds.isEmpty) return _emptyReport();

    final snapshots = await Future.wait(
      walletIds.map(
        (walletId) => _firestore
            .collection('wallets')
            .doc(walletId)
            .collection('transactions')
            .where(
              'createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
            )
            .where(
              'createdAt',
              isLessThanOrEqualTo: Timestamp.fromDate(endDate),
            )
            .get(),
      ),
    );

    return _aggregate(snapshots.expand((snapshot) => snapshot.docs));
  }

  TransactionReportEntity _aggregate(
    Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> documents,
  ) {
    var income = 0.0;
    var outcome = 0.0;
    var count = 0;
    var receivedCount = 0;
    var sentCount = 0;
    final byDay = <DateTime, double>{};

    for (final document in documents) {
      final data = document.data();
      final typeValue = data['type'];
      final createdAtValue = data['createdAt'];
      if (typeValue is! String || createdAtValue is! Timestamp) continue;

      try {
        final type = TransactionType.fromString(typeValue);
        final amount = (data['amount'] as num? ?? 0).toDouble();
        final createdAt = createdAtValue.toDate();
        final day = DateTime(createdAt.year, createdAt.month, createdAt.day);
        count++;

        switch (type) {
          case TransactionType.receive:
            income += amount;
            receivedCount++;
            byDay.update(
              day,
              (value) => value + amount,
              ifAbsent: () => amount,
            );
          case TransactionType.send:
            outcome += amount;
            sentCount++;
            byDay.update(
              day,
              (value) => value - amount,
              ifAbsent: () => -amount,
            );
        }
      } catch (error, stackTrace) {
        log(
          'Skipping malformed transaction ${document.id}: $error',
          name: 'TransactionReportRemoteDataSource',
          stackTrace: stackTrace,
        );
      }
    }

    return TransactionReportEntity(
      totalIncome: income,
      totalOutcome: outcome,
      balanceChange: income - outcome,
      transactionCount: count,
      transactionsByDay: byDay,
      receivedTransactionCount: receivedCount,
      sentTransactionCount: sentCount,
    );
  }

  TransactionReportEntity _emptyReport() => const TransactionReportEntity(
    totalIncome: 0,
    totalOutcome: 0,
    balanceChange: 0,
    transactionCount: 0,
    transactionsByDay: <DateTime, double>{},
    receivedTransactionCount: 0,
    sentTransactionCount: 0,
  );
}
