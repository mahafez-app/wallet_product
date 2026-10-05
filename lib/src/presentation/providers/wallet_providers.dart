import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/cache/wallet_meta_cache.dart';
import '../../data/datasources/wallet_details_remote_data_source.dart';
import '../../data/datasources/wallet_details_remote_data_source_impl.dart';
import '../../data/datasources/wallet_remote_data_source.dart';
import '../../data/datasources/wallet_remote_data_source_impl.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../domain/usecases/add_wallets_usecase.dart';
import '../../domain/usecases/delete_wallet_usecase.dart';
import '../../domain/usecases/get_wallets_usecase.dart';
import '../../domain/usecases/reset_wallet_stats_usecase.dart';
import '../../domain/usecases/update_wallet_balance_usecase.dart';
import '../../domain/usecases/get_wallet_details_usecase.dart';

// ── Injected External Providers (can be overridden in shell) ─────────────────

final walletFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final walletAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final walletDeviceIdProvider = Provider<Future<String> Function()>((ref) {
  return () async => 'unknown_device_id';
});

final walletMetaCacheProvider = Provider<WalletMetaCache>((ref) {
  return WalletMetaCache();
});

// ── Internal Package Providers ───────────────────────────────────────────────

final walletRemoteDataSourceProvider = Provider<WalletRemoteDataSource>((ref) {
  return WalletRemoteDataSourceImpl(
    firestore: ref.watch(walletFirestoreProvider),
    auth: ref.watch(walletAuthProvider),
  );
});

final walletDetailsRemoteDataSourceProvider =
    Provider<WalletDetailsRemoteDataSource>((ref) {
      return WalletDetailsRemoteDataSourceImpl(
        firestore: ref.watch(walletFirestoreProvider),
      );
    });

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepositoryImpl(
    remoteDataSource: ref.watch(walletRemoteDataSourceProvider),
    detailsDataSource: ref.watch(walletDetailsRemoteDataSourceProvider),
    deviceIdProvider: ref.watch(walletDeviceIdProvider),
    walletMetaCache: ref.watch(walletMetaCacheProvider),
  );
});

final addWalletsUseCaseProvider = Provider<AddWalletsUseCase>((ref) {
  return AddWalletsUseCase(ref.watch(walletRepositoryProvider));
});

final getWalletDetailsUseCaseProvider = Provider<GetWalletDetailsUseCase>((ref) {
  return GetWalletDetailsUseCase(ref.watch(walletRepositoryProvider));
});

final getWalletsUseCaseProvider = Provider<GetWalletsUseCase>((ref) {
  return GetWalletsUseCase(ref.watch(walletRepositoryProvider));
});

final deleteWalletUseCaseProvider = Provider<DeleteWalletUseCase>((ref) {
  return DeleteWalletUseCase(ref.watch(walletRepositoryProvider));
});

final resetWalletStatsUseCaseProvider = Provider<ResetWalletStatsUseCase>((ref) {
  return ResetWalletStatsUseCase(ref.watch(walletRepositoryProvider));
});

final updateWalletBalanceUseCaseProvider =
    Provider<UpdateWalletBalanceUseCase>((ref) {
      return UpdateWalletBalanceUseCase(ref.watch(walletRepositoryProvider));
    });
