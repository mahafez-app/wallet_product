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
  ];
}
