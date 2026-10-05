import 'package:sms_engine/sms_engine.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/transaction_entity.dart';

final class SmsTransactionEntityBuilder {
  SmsTransactionEntityBuilder._();

  static const _uuid = Uuid();

  /// Converts an [SmsParseResult] into a fully hydrated [TransactionEntity].
  static TransactionEntity build({
    required SmsParseResult result,
    required String walletId,
    required String walletOwnerUid,
    required String walletPhoneNumber,
    required String rawMessage,
  }) {
    // Generate deterministic ID so retries don't create duplicates
    final deterministicId = _uuid.v5(
      Namespace.url.value,
      '${result.provider}_${rawMessage.trim()}_${result.createdAt.millisecondsSinceEpoch}_$walletId',
    );

    return TransactionEntity(
      id: deterministicId,
      type: result.type,
      amount: result.amount,
      createdAt: result.createdAt,
      walletId: walletId,
      walletOwnerUid: walletOwnerUid,
      provider: result.provider,
      phoneNumber: walletPhoneNumber,
      counterpartyNumber: result.counterpartyNumber,
      referenceNumber: result.referenceNumber,
      isPaid: null,
      message: rawMessage,
      statusBalance: result.balance,
    );
  }
}
