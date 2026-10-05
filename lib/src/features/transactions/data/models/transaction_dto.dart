import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahafez_core/mahafez_core.dart';

import '../../domain/entities/transaction_entity.dart';
import 'transaction_search_terms.dart';

final class TransactionDto extends TransactionEntity {
  const TransactionDto({
    required super.id,
    required super.type,
    required super.amount,
    required super.createdAt,
    required super.walletId,
    required super.walletOwnerUid,
    required super.provider,
    required super.phoneNumber,
    super.counterpartyNumber,
    super.referenceNumber,
    super.isPaid,
    super.message,
    super.statusBalance,
  });

  factory TransactionDto.fromFirestore(
    DocumentSnapshot doc,
    WalletProvider provider,
    String phoneNumber,
    String walletId,
    String walletOwnerUid,
  ) {
    final data = doc.data() as Map<String, dynamic>;

    return TransactionDto(
      id: doc.id,
      type: TransactionType.fromString(data['type']),
      amount: (data['amount'] as num? ?? 0.0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
      walletId: walletId,
      walletOwnerUid: walletOwnerUid,
      provider: provider,
      phoneNumber: phoneNumber,
      counterpartyNumber: data['counterpartyNumber'] as String?,
      referenceNumber: data['referenceNumber'] as String?,
      isPaid: data['isPaid'] as bool? ?? false,
      message: data['message'] as String?,
      statusBalance: (data['statusBalance'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'type': type.name,
    'amount': amount,
    'createdAt': Timestamp.fromDate(createdAt),
    'counterpartyNumber': counterpartyNumber,
    'counterpartySuffixes': TransactionSearchTerms.counterpartySuffixes(
      counterpartyNumber,
    ),
    'referenceNumber': referenceNumber,
    'isPaid': type == TransactionType.receive ? (isPaid ?? false) : isPaid,
    'message': message,
    'statusBalance': statusBalance,
  };

  TransactionEntity toEntity() => TransactionEntity(
    id: id,
    type: type,
    amount: amount,
    createdAt: createdAt,
    walletId: walletId,
    walletOwnerUid: walletOwnerUid,
    provider: provider,
    phoneNumber: phoneNumber,
    counterpartyNumber: counterpartyNumber,
    referenceNumber: referenceNumber,
    isPaid: isPaid,
    message: message,
    statusBalance: statusBalance,
  );

  factory TransactionDto.fromEntity(TransactionEntity entity) => TransactionDto(
        id: entity.id,
        type: entity.type,
        amount: entity.amount,
        createdAt: entity.createdAt,
        walletId: entity.walletId,
        walletOwnerUid: entity.walletOwnerUid,
        provider: entity.provider,
        phoneNumber: entity.phoneNumber,
        counterpartyNumber: entity.counterpartyNumber,
        referenceNumber: entity.referenceNumber,
        isPaid: entity.isPaid,
        message: entity.message,
        statusBalance: entity.statusBalance,
      );

  @override
  TransactionDto copyWith({
    String? id,
    TransactionType? type,
    double? amount,
    DateTime? createdAt,
    String? walletId,
    String? walletOwnerUid,
    WalletProvider? provider,
    String? phoneNumber,
    String? counterpartyNumber,
    String? referenceNumber,
    bool? isPaid,
    String? message,
    double? statusBalance,
  }) {
    return TransactionDto(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      walletId: walletId ?? this.walletId,
      walletOwnerUid: walletOwnerUid ?? this.walletOwnerUid,
      provider: provider ?? this.provider,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      counterpartyNumber: counterpartyNumber ?? this.counterpartyNumber,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      isPaid: isPaid ?? this.isPaid,
      message: message ?? this.message,
      statusBalance: statusBalance ?? this.statusBalance,
    );
  }
}
