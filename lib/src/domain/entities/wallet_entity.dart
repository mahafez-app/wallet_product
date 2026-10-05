import 'package:equatable/equatable.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:mahafez_sms_engine/mahafez_sms_engine.dart';

class WalletEntity extends Equatable implements SmsWalletCandidate {
  const WalletEntity({
    required this.id,
    required this.phoneNumber,
    required this.provider,
    required this.deviceId,
    required this.ownerUid,
    required this.currentBalance,
    required this.totalReceived,
    required this.totalSent,
    required this.lastBalanceAt,
    required this.createdAt,
    this.statsResetAt,
    this.latestActivityBalance,
  });

  @override
  final String id;
  @override
  final String phoneNumber;
  final WalletProvider provider;
  final String deviceId;
  final String ownerUid;
  @override
  final double currentBalance;
  final double totalReceived;
  final double totalSent;
  final DateTime lastBalanceAt;
  final DateTime createdAt;
  final DateTime? statsResetAt;
  final double? latestActivityBalance;

  double get suggestedBalance => latestActivityBalance ?? currentBalance;

  static const _unset = Object();

  WalletEntity copyWith({
    String? id,
    String? phoneNumber,
    WalletProvider? provider,
    String? deviceId,
    String? ownerUid,
    double? currentBalance,
    double? totalReceived,
    double? totalSent,
    DateTime? lastBalanceAt,
    DateTime? createdAt,
    Object? statsResetAt = _unset,
    Object? latestActivityBalance = _unset,
  }) {
    return WalletEntity(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      provider: provider ?? this.provider,
      deviceId: deviceId ?? this.deviceId,
      ownerUid: ownerUid ?? this.ownerUid,
      currentBalance: currentBalance ?? this.currentBalance,
      totalReceived: totalReceived ?? this.totalReceived,
      totalSent: totalSent ?? this.totalSent,
      lastBalanceAt: lastBalanceAt ?? this.lastBalanceAt,
      createdAt: createdAt ?? this.createdAt,
      statsResetAt: identical(statsResetAt, _unset)
          ? this.statsResetAt
          : statsResetAt as DateTime?,
      latestActivityBalance: identical(latestActivityBalance, _unset)
          ? this.latestActivityBalance
          : latestActivityBalance as double?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    phoneNumber,
    provider,
    deviceId,
    ownerUid,
    currentBalance,
    totalReceived,
    totalSent,
    lastBalanceAt,
    createdAt,
    statsResetAt,
    latestActivityBalance,
  ];
}
