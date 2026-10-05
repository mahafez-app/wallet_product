import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahafez_core/mahafez_core.dart';

import '../models/wallet_dto.dart';
import 'wallet_remote_data_source.dart';

final class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  const WalletRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

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
        technicalMessage:
            'A wallet already exists for this owner, provider, and phone number.',
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

    final workspaceLinks = await _getWorkspaceLinks(walletId);
    await _deleteWalletTransactions(walletRef);
    await _deleteInBatches(workspaceLinks.linkReferences);
    await walletRef.delete();

    for (final workspaceId in workspaceLinks.workspaceIds) {
      await _syncWorkspaceMetadata(workspaceId);
    }
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

  Future<_WorkspaceLinks> _getWorkspaceLinks(String walletId) async {
    final linksQuery = await _firestore
        .collectionGroup('wallets')
        .where('walletId', isEqualTo: walletId)
        .get();

    return _WorkspaceLinks(
      workspaceIds: linksQuery.docs
          .map((doc) => doc.reference.parent.parent?.id)
          .whereType<String>()
          .toSet(),
      linkReferences: linksQuery.docs.map((doc) => doc.reference).toList(),
    );
  }

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

  Future<void> _syncWorkspaceMetadata(String workspaceId) async {
    final workspaceRef = _firestore.collection('workspaces').doc(workspaceId);
    final walletsQuery = await workspaceRef.collection('wallets').get();
    final walletIds = walletsQuery.docs.map((doc) => doc.id).toList();

    if (walletIds.isEmpty) {
      await workspaceRef.update({'walletsCount': 0, 'latestActivityAt': null});
      return;
    }

    final snapshots = await Future.wait(
      walletIds.map((id) => _firestore.collection('wallets').doc(id).get()),
    );

    final wallets = snapshots
        .where((s) => s.exists)
        .map(WalletDto.fromFirestore)
        .toList();

    final latestActivityAt = wallets.isEmpty
        ? null
        : wallets
              .map((w) => w.lastBalanceAt)
              .reduce((a, b) => a.isAfter(b) ? a : b);

    await workspaceRef.update({
      'walletsCount': wallets.length,
      'latestActivityAt': latestActivityAt == null
          ? null
          : Timestamp.fromDate(latestActivityAt),
    });
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

final class _WorkspaceLinks {
  const _WorkspaceLinks({
    required this.workspaceIds,
    required this.linkReferences,
  });

  final Set<String> workspaceIds;
  final List<DocumentReference<Map<String, dynamic>>> linkReferences;
}
