import '../models/transaction_dto.dart';
import 'transaction_firestore_support.dart';

abstract interface class TransactionWatchRemoteDataSource {
  Stream<TransactionDto> watchTransaction({
    required String walletId,
    required String transactionId,
  });
}

final class TransactionWatchRemoteDataSourceImpl
    implements TransactionWatchRemoteDataSource {
  const TransactionWatchRemoteDataSourceImpl({
    required TransactionFirestoreSupport support,
  }) : _support = support;

  final TransactionFirestoreSupport _support;

  @override
  Stream<TransactionDto> watchTransaction({
    required String walletId,
    required String transactionId,
  }) async* {
    final meta = await _support.walletMeta(walletId);

    yield* _support
        .txCollection(walletId)
        .doc(transactionId)
        .snapshots()
        .where((snapshot) => snapshot.exists)
        .map(
          (snapshot) => TransactionDto.fromFirestore(
            snapshot,
            meta.provider,
            meta.phoneNumber,
            walletId,
            meta.ownerUid,
          ),
        );
  }
}
