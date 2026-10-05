import '../../domain/entities/transactions_overview_entity.dart';

final class ActiveWalletDto extends ActiveWalletEntity {
  const ActiveWalletDto({
    required super.walletId,
    required super.provider,
    required super.phoneNumber,
    required super.lastActivityAt,
  });

  ActiveWalletEntity toEntity() => ActiveWalletEntity(
    walletId: walletId,
    provider: provider,
    phoneNumber: phoneNumber,
    lastActivityAt: lastActivityAt,
  );
}

final class TransactionsOverviewDto extends TransactionsOverviewEntity {
  const TransactionsOverviewDto({
    required super.todayCollected,
    required super.todaySent,
    required super.unpaidCount,
    required super.latestActiveWallets,
  });

  TransactionsOverviewEntity toEntity() => TransactionsOverviewEntity(
    todayCollected: todayCollected,
    todaySent: todaySent,
    unpaidCount: unpaidCount,
    latestActiveWallets: latestActiveWallets
        .map((wallet) => (wallet as ActiveWalletDto).toEntity())
        .toList(),
  );
}
