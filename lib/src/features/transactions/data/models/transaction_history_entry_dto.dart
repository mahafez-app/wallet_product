import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/transaction_history_entry_entity.dart';

final class TransactionHistoryEntryDto extends TransactionHistoryEntryEntity {
  const TransactionHistoryEntryDto({
    required super.id,
    required super.isPaid,
    required super.actorName,
    required super.actorUid,
    required super.occurredAt,
  });

  factory TransactionHistoryEntryDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionHistoryEntryDto(
      id: doc.id,
      isPaid: data['isPaid'] as bool? ?? false,
      actorName: data['actorName'] as String? ?? '',
      actorUid: data['actorUid'] as String? ?? '',
      occurredAt: (data['occurredAt'] as Timestamp? ?? Timestamp.now())
          .toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'isPaid': isPaid,
    'actorName': actorName,
    'actorUid': actorUid,
    'occurredAt': Timestamp.fromDate(occurredAt),
  };

  TransactionHistoryEntryEntity toEntity() => TransactionHistoryEntryEntity(
    id: id,
    isPaid: isPaid,
    actorName: actorName,
    actorUid: actorUid,
    occurredAt: occurredAt,
  );
}
