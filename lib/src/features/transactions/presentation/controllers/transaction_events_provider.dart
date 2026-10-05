import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/transaction_entity.dart';

final transactionUpdatesProvider =
    NotifierProvider.autoDispose<
      TransactionUpdatesNotifier,
      TransactionEvent?
    >(TransactionUpdatesNotifier.new);

sealed class TransactionEvent {
  const TransactionEvent();
}

final class TransactionUpdatedEvent extends TransactionEvent {
  const TransactionUpdatedEvent(this.transaction);

  final TransactionEntity transaction;
}

final class TransactionDeletedEvent extends TransactionEvent {
  const TransactionDeletedEvent({
    required this.walletId,
    required this.transactionId,
  });

  final String walletId;
  final String transactionId;
}

class TransactionUpdatesNotifier extends Notifier<TransactionEvent?> {
  @override
  TransactionEvent? build() => null;

  void notifyUpdated(TransactionEntity transaction) =>
      state = TransactionUpdatedEvent(transaction);

  void notifyDeleted({required String walletId, required String transactionId}) {
    state = TransactionDeletedEvent(
      walletId: walletId,
      transactionId: transactionId,
    );
  }
}
