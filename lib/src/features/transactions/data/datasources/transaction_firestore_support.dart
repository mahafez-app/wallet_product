import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../wallets/data/cache/wallet_meta_cache.dart';
import '../../../wallets/data/models/wallet_dto.dart';
import 'package:mahafez_core/mahafez_core.dart';
import '../../domain/entities/transaction_paid_status_filter.dart';
import '../../domain/entities/transaction_date_range.dart';
import '../../domain/entities/transaction_page.dart';
import '../models/transaction_search_terms.dart';

class TransactionFirestoreSupport {
  const TransactionFirestoreSupport({
    required FirebaseFirestore firestore,
    required WalletMetaCache metaCache,
  }) : _firestore = firestore,
       _metaCache = metaCache;

  final FirebaseFirestore _firestore;
  final WalletMetaCache _metaCache;

  DocumentReference<Map<String, dynamic>> walletDocument(String walletId) =>
      _firestore.collection('wallets').doc(walletId);

  CollectionReference<Map<String, dynamic>> txCollection(String walletId) =>
      walletDocument(walletId).collection('transactions');

  /// Returns wallet provider/phone/ownerUid, hitting the in-memory TTL cache
  /// before falling back to a Firestore document read.
  ///
  /// For 3 wallets loading one page, this reduces 3 redundant
  /// Firestore reads to at most 1 per wallet per TTL window.
  Future<({WalletProvider provider, String phoneNumber, String ownerUid})>
  walletMeta(String walletId) async {
    final cached = _metaCache.get(walletId);
    if (cached != null) {
      return (
        provider: WalletProvider.fromString(cached.provider),
        phoneNumber: cached.phoneNumber,
        ownerUid: cached.ownerUid,
      );
    }

    final doc = await walletDocument(walletId).get();
    final wallet = WalletDto.fromFirestore(doc);

    _metaCache.put(
      walletId,
      WalletMeta(
        provider: wallet.provider.toValue,
        phoneNumber: wallet.phoneNumber,
        ownerUid: wallet.ownerUid,
      ),
    );

    return (
      provider: wallet.provider,
      phoneNumber: wallet.phoneNumber,
      ownerUid: wallet.ownerUid,
    );
  }

  Query<Map<String, dynamic>> applyFilters(
    Query<Map<String, dynamic>> query, {
    TransactionType? type,
    TransactionPaidStatusFilter paidStatusFilter =
        TransactionPaidStatusFilter.all,
    String? counterpartySuffixQuery,
    TransactionDateRange? dateRange,
  }) {
    var filteredQuery = query;
    if (type != null) {
      filteredQuery = filteredQuery.where('type', isEqualTo: type.name);
    }
    if (paidStatusFilter != TransactionPaidStatusFilter.all) {
      filteredQuery = filteredQuery.where(
        'isPaid',
        isEqualTo: paidStatusFilter == TransactionPaidStatusFilter.paid,
      );
    }
    final normalizedSuffix = TransactionSearchTerms.normalizeDigits(
      counterpartySuffixQuery,
    );
    if (normalizedSuffix.length >= 2) {
      filteredQuery = filteredQuery.where(
        'counterpartySuffixes',
        arrayContains: normalizedSuffix,
      );
    }
    if (dateRange != null) {
      filteredQuery = filteredQuery
          .where(
            'createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(dateRange.start),
          )
          .where(
            'createdAt',
            isLessThanOrEqualTo: Timestamp.fromDate(dateRange.end),
          );
    }
    return filteredQuery;
  }

  Query<Map<String, dynamic>> walletTransactionsQuery(String walletId) =>
      txCollection(walletId)
          .orderBy('createdAt', descending: true)
          .orderBy(FieldPath.documentId, descending: true);

  TransactionDateRange todayRange() {
    final now = DateTime.now();
    return TransactionDateRange(
      start: DateTime(now.year, now.month, now.day),
      end: now,
    );
  }

  WalletTransactionsPageCursor toWalletCursor(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final createdAt =
        (document.data()['createdAt'] as Timestamp? ?? Timestamp.now())
            .toDate();

    return WalletTransactionsPageCursor(
      createdAt: createdAt,
      transactionId: document.id,
    );
  }
}
