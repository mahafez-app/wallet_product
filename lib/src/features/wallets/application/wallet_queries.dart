import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/datasources/wallet_remote_data_source_impl.dart';
import '../domain/entities/wallet_entity.dart';

/// Supported product API for resolving wallets without exposing persistence DTOs.
final class WalletQueries {
  WalletQueries({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _dataSource = WalletRemoteDataSourceImpl(
         firestore: firestore,
         auth: auth,
       );

  final WalletRemoteDataSourceImpl _dataSource;

  Future<List<WalletEntity>> getByIds(List<String> walletIds) async =>
      (await _dataSource.getWalletsByIds(walletIds))
          .map((wallet) => wallet.toEntity())
          .toList();

  Stream<List<WalletEntity>> watchMine() => _dataSource.watchWallets().map(
    (wallets) => wallets.map((wallet) => wallet.toEntity()).toList(),
  );

  Stream<List<WalletEntity>> watchByIds(List<String> walletIds) => _dataSource
      .watchWalletsByIds(walletIds)
      .map((wallets) => wallets.map((wallet) => wallet.toEntity()).toList());

  Future<List<WalletEntity>> getByOwnerAndProvider({
    required String ownerUid,
    required String provider,
  }) async => (await _dataSource.getWalletsByOwnerAndProvider(
    ownerUid: ownerUid,
    provider: provider,
  )).map((wallet) => wallet.toEntity()).toList();
}
