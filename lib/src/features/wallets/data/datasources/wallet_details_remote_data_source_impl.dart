import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/wallet_dto.dart';
import 'wallet_details_remote_data_source.dart';

final class WalletDetailsRemoteDataSourceImpl
    implements WalletDetailsRemoteDataSource {
  const WalletDetailsRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<WalletDto> getWallet(String walletId) async {
    final doc = await _firestore.collection('wallets').doc(walletId).get();
    return WalletDto.fromFirestore(doc);
  }

  @override
  Future<double?> getLatestActivityBalance(String walletId) async {
    final snapshot = await _firestore
        .collection('wallets')
        .doc(walletId)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    final data = snapshot.docs.first.data();
    return (data['statusBalance'] as num?)?.toDouble();
  }
}
