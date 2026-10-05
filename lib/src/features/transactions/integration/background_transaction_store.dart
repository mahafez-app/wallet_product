import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../../wallets/data/cache/wallet_meta_cache.dart';
import '../data/datasources/transaction_firestore_support.dart';
import '../data/datasources/deleted_transaction_local_data_source.dart';
import '../data/datasources/wallet_transaction_remote_data_source.dart';
import '../domain/entities/transaction_entity.dart';

/// Persistence boundary used by the host's platform background entry point.
final class BackgroundTransactionStore {
  BackgroundTransactionStore({
    required FirebaseFirestore firestore,
    required Box<String> deletedTransactionIds,
  }) : _deletedTransactions = DeletedTransactionLocalDataSourceImpl(
         box: deletedTransactionIds,
       ),
       _transactions = WalletTransactionRemoteDataSourceImpl(
         support: TransactionFirestoreSupport(
           firestore: firestore,
           metaCache: WalletMetaCache(),
         ),
       );

  final DeletedTransactionLocalDataSource _deletedTransactions;
  final WalletTransactionRemoteDataSource _transactions;

  Future<void> pruneExpiredTombstones() => _deletedTransactions.pruneExpired();

  Future<bool> isTransactionDeleted(String transactionId) =>
      _deletedTransactions.isDeleted(transactionId);

  Future<void> save(TransactionEntity transaction) =>
      _transactions.saveTransaction(transaction);
}
