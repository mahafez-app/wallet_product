import 'package:mahafez_core/mahafez_core.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../cache/wallet_meta_cache.dart';
import '../datasources/wallet_details_remote_data_source.dart';
import '../datasources/wallet_remote_data_source.dart';

final class WalletRepositoryImpl implements WalletRepository {
  const WalletRepositoryImpl({
    required WalletRemoteDataSource remoteDataSource,
    required WalletDetailsRemoteDataSource detailsDataSource,
    required Future<String> Function() deviceIdProvider,
    required WalletMetaCache walletMetaCache,
  }) : _remoteDataSource = remoteDataSource,
       _detailsDataSource = detailsDataSource,
       _deviceIdProvider = deviceIdProvider,
       _walletMetaCache = walletMetaCache;

  final WalletRemoteDataSource _remoteDataSource;
  final WalletDetailsRemoteDataSource _detailsDataSource;
  final Future<String> Function() _deviceIdProvider;
  final WalletMetaCache _walletMetaCache;

  @override
  Future<Result<List<WalletEntity>>> getWallets() {
    return _execute(() async {
      final wallets = await _remoteDataSource.getWallets();
      return wallets.map((dto) => dto.toEntity()).toList();
    });
  }

  @override
  Future<Result<void>> addWallets({
    required String phoneNumber,
    required List<String> providers,
    Map<String, double> initialBalances = const {},
  }) {
    return _execute(() async {
      final deviceId = await _deviceIdProvider();
      await _remoteDataSource.addWallets(
        phoneNumber: phoneNumber,
        providers: providers,
        initialBalances: initialBalances,
        deviceId: deviceId,
      );
    });
  }

  @override
  Future<Result<WalletEntity>> getWalletDetails(String walletId) {
    return _execute(() async {
      final walletDto = await _detailsDataSource.getWallet(walletId);
      final latestBalance = await _detailsDataSource.getLatestActivityBalance(walletId);
      return walletDto.toEntity().copyWith(
        latestActivityBalance: latestBalance,
      );
    });
  }

  @override
  Future<Result<void>> deleteWallet(String walletId) {
    return _execute(() async {
      await _remoteDataSource.deleteWallet(walletId);
      _walletMetaCache.invalidate(walletId);
    });
  }

  @override
  Future<Result<void>> resetWalletStats(String walletId) {
    return _execute(() async {
      await _remoteDataSource.resetWalletStats(walletId);
    });
  }

  @override
  Future<Result<void>> updateWalletBalance({
    required String walletId,
    required double balance,
  }) {
    return _execute(() async {
      await _remoteDataSource.updateWalletBalance(
        walletId: walletId,
        balance: balance,
      );
    });
  }

  Future<Result<T>> _execute<T>(Future<T> Function() action) async {
    try {
      final value = await action();
      return Success(value);
    } on Failure catch (failure) {
      return FailureResult(failure);
    } catch (e) {
      return FailureResult(UnknownFailure(
        technicalMessage: e.toString(),
      ));
    }
  }
}
