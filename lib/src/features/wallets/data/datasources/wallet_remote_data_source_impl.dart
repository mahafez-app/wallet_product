import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:rxdart/rxdart.dart';

import '../models/wallet_dto.dart';
import 'wallet_remote_data_source.dart';

final class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  const WalletRemoteDataSourceImpl({
    required this._firestore,
    required this._auth,
  });

  @override
  Future<List<WalletDto>> getWallets() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw const UnknownFailure(technicalMessage: 'User is not logged in');
    }

    final query = await _firestore
        .collection('wallets')
        .where('ownerUid', isEqualTo: currentUser.uid)
        .get();

    return query.docs.map((doc) => WalletDto.fromFirestore(doc)).toList();
  }

  @override
  Stream<List<WalletDto>> watchWallets() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.error(
        const UnknownFailure(technicalMessage: 'User is not logged in'),
      );
    }
    return _firestore
        .collection('wallets')
        .where('ownerUid', isEqualTo: currentUser.uid)
        .snapshots()
        .map((query) => query.docs.map(WalletDto.fromFirestore).toList());
  }

  @override
  Future<List<WalletDto>> getWalletsByIds(List<String> walletIds) async {
    if (walletIds.isEmpty) return const [];
    final documents = await Future.wait(
      walletIds.map((id) => _firestore.collection('wallets').doc(id).get()),
    );
    return documents
        .where((document) => document.exists)
        .map(WalletDto.fromFirestore)
        .toList();
  }

  @override
  Stream<List<WalletDto>> watchWalletsByIds(List<String> walletIds) {
    if (walletIds.isEmpty) return Stream.value(const []);
    final walletStreams = walletIds.toSet().map(
      (id) => _firestore.collection('wallets').doc(id).snapshots(),
    );
    return Rx.combineLatestList(walletStreams).map(
      (documents) => documents
          .where((document) => document.exists)
          .map(WalletDto.fromFirestore)
          .toList(),
    );
  }

  @override
  Future<List<WalletDto>> getWalletsByOwnerAndProvider({
    required String ownerUid,
    required String provider,
  }) async {
    final query = await _firestore
        .collection('wallets')
        .where('ownerUid', isEqualTo: ownerUid)
        .where('provider', isEqualTo: provider)
        .get();
    return query.docs.map(WalletDto.fromFirestore).toList();
  }

  @override
  Future<List<WalletDto>> addWallets({
    required String phoneNumber,
    required List<String> providers,
    required Map<String, double> initialBalances,
    required String deviceId,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw const UnknownFailure(technicalMessage: 'User is not logged in');
    }

    final normalizedPhoneNumber = EgyptianPhoneNumber.normalize(phoneNumber);
    final existingProvidersSet = await _findExistingProviders(
      ownerUid: currentUser.uid,
      normalizedPhoneNumber: normalizedPhoneNumber,
      providers: providers,
    );

    final providersToCreate = providers
        .where((p) => !existingProvidersSet.contains(p))
        .toList();

    if (providersToCreate.isEmpty) {
      throw const ValidationFailure(
        code: 'wallet-already-exists',
        technicalMessage: 'A wallet already exists for this owner, provider, and phone number.',
      );
    }

    final batch = _firestore.batch();
    final List<WalletDto> createdWallets = [];
    final now = DateTime.now();

    for (final providerStr in providersToCreate) {
      final docRef = _firestore.collection('wallets').doc();
      final initialBalance = initialBalances[providerStr] ?? 0.0;
      final provider = WalletProvider.fromString(providerStr);

      final walletDto = WalletDto(
        id: docRef.id,
        phoneNumber: normalizedPhoneNumber,
        provider: provider,
        deviceId: deviceId,
        ownerUid: currentUser.uid,
        currentBalance: initialBalance,
        totalReceived: 0.0,
        totalSent: 0.0,
        lastBalanceAt: now,
        createdAt: now,
      );
      batch.set(docRef, walletDto.toFirestore());
      createdWallets.add(walletDto);
    }

    await batch.commit();
    return createdWallets;
  }

  @override
  Future<void> deleteWallet(String walletId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw const UnknownFailure(technicalMessage: 'User is not logged in');
    }

    final walletRef = _firestore.collection('wallets').doc(walletId);
    final walletSnapshot = await walletRef.get();
    if (!walletSnapshot.exists) return;

    final wallet = WalletDto.fromFirestore(walletSnapshot);
    if (wallet.ownerUid != currentUser.uid) {
      throw const PermissionFailure(
        technicalMessage: 'Only the wallet owner can delete it.',
      );
    }

    await _deleteWalletTransactions(walletRef);
    await walletRef.delete();
  }

  @override
  Future<void> resetWalletStats(String walletId) async {
    await _firestore.collection('wallets').doc(walletId).update({
      'totalReceived': 0.0,
      'totalSent': 0.0,
      'statsResetAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateWalletBalance({
    required String walletId,
    required double balance,
  }) async {
    await _firestore.collection('wallets').doc(walletId).update({
      'currentBalance': balance,
      'lastBalanceAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  Future<void> _deleteWalletTransactions(
    DocumentReference<Map<String, dynamic>> walletRef,
  ) async {
    while (true) {
      final snapshot = await walletRef
          .collection('transactions')
          .limit(100)
          .get();
      if (snapshot.docs.isEmpty) {
        return;
      }

      for (final document in snapshot.docs) {
        await _deleteTransactionChildren(document.reference);
      }

      await _deleteInBatches(
        snapshot.docs.map((document) => document.reference).toList(),
      );
    }
  }

  Future<void> _deleteTransactionChildren(
    DocumentReference<Map<String, dynamic>> transactionRef,
  ) async {
    await _deleteCollection(transactionRef.collection('history'));
    await _deleteCollection(transactionRef.collection('notes'));
  }

  Future<void> _deleteCollection(
    CollectionReference<Map<String, dynamic>> collection,
  ) async {
    while (true) {
      final snapshot = await collection.limit(200).get();
      if (snapshot.docs.isEmpty) {
        return;
      }

      await _deleteInBatches(
        snapshot.docs.map((document) => document.reference).toList(),
      );
    }
  }

  Future<void> _deleteInBatches(List<DocumentReference> references) async {
    for (var i = 0; i < references.length; i += 450) {
      final batch = _firestore.batch();
      final end = (i + 450 > references.length) ? references.length : i + 450;
      for (final ref in references.sublist(i, end)) {
        batch.delete(ref);
      }
      await batch.commit();
    }
  }

  Future<Set<String>> _findExistingProviders({
    required String ownerUid,
    required String normalizedPhoneNumber,
    required List<String> providers,
  }) async {
    final existingQuery = await _firestore
        .collection('wallets')
        .where('ownerUid', isEqualTo: ownerUid)
        .where('provider', whereIn: providers)
        .get();

    return existingQuery.docs
        .map(WalletDto.fromFirestore)
        .where(
          (wallet) =>
              EgyptianPhoneNumber.normalize(wallet.phoneNumber) ==
              normalizedPhoneNumber,
        )
        .map((wallet) => wallet.provider.toValue)
        .toSet();
  }
}
