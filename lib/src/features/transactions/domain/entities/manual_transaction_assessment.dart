import 'package:equatable/equatable.dart';


import 'transaction_entity.dart';
import '../../../wallets/domain/entities/wallet_entity.dart';

enum ManualTransactionReviewKind {
  none,
  needsConfirmation,
  explicitWalletMismatch,
  inferredWalletMismatch,
}

final class ManualTransactionAssessment extends Equatable {
  const ManualTransactionAssessment({
    required this.transaction,
    this.reviewKind = ManualTransactionReviewKind.none,
    this.suggestedWallet,
    this.explicitWalletPhone,
  });

  final TransactionEntity transaction;
  final ManualTransactionReviewKind reviewKind;
  final WalletEntity? suggestedWallet;
  final String? explicitWalletPhone;

  bool get requiresReview =>
      reviewKind != ManualTransactionReviewKind.none;

  bool get allowsSaveToSelectedWallet => true;

  @override
  List<Object?> get props => [
    transaction,
    reviewKind,
    suggestedWallet,
    explicitWalletPhone,
  ];
}
