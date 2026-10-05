import 'package:mahafez_core/mahafez_core.dart';
import 'package:sms_engine/sms_engine.dart';
import 'package:uuid/uuid.dart';

import '../../../wallets/domain/entities/wallet_entity.dart';
import '../../../wallets/domain/repositories/wallet_repository.dart';
import '../entities/manual_transaction_assessment.dart';
import '../entities/transaction_entity.dart';

final class ProcessManualTransactionParams {
  const ProcessManualTransactionParams({
    required this.walletId,
    required this.message,
    required this.smsReceivedAt,
  });

  final String walletId;
  final String message;
  final DateTime smsReceivedAt;
}

final class ProcessManualTransactionUseCase
    implements
        UseCase<
          ManualTransactionAssessment,
          ProcessManualTransactionParams
        > {
  const ProcessManualTransactionUseCase(this._walletRepository);

  final WalletRepository _walletRepository;

  static const _uuid = Uuid();

  @override
  Future<Result<ManualTransactionAssessment>> call(
    ProcessManualTransactionParams params,
  ) async {
    final walletsResult = await _walletRepository.getWallets();
    return walletsResult.fold(
      FailureResult.new,
      (wallets) => _process(wallets: wallets, params: params),
    );
  }

  Result<ManualTransactionAssessment> _process({
    required List<WalletEntity> wallets,
    required ProcessManualTransactionParams params,
  }) {
    final trimmedMessage = params.message.trim();
    if (trimmedMessage.isEmpty) {
      return const FailureResult(
        ValidationFailure(code: 'manual-transaction-message-required'),
      );
    }

    final selectedWallet = _findWalletById(wallets, params.walletId);
    if (selectedWallet == null) {
      return const FailureResult(ValidationFailure(code: 'wallet-not-found'));
    }

    final parser = SmsParserRegistry.resolveByProvider(selectedWallet.provider);
    final parseResult = parser?.parse(
      trimmedMessage,
      params.smsReceivedAt,
      useContentDate: true,
    );
    if (parseResult == null) {
      return const FailureResult(
        ValidationFailure(code: 'manual-transaction-unrecognized'),
      );
    }

    final explicitWalletPhone = _resolveIntendedWalletPhone(
      trimmedMessage,
      parseResult.counterpartyNumber,
    );

    final transaction = _buildTransactionEntity(
      result: parseResult,
      wallet: selectedWallet,
      rawMessage: trimmedMessage,
    );

    final assessment = ManualTransactionAssessment(
      transaction: transaction,
      explicitWalletPhone: explicitWalletPhone,
    );

    final input = SmsWalletMatchInput(
      amount: parseResult.amount,
      transactionType: parseResult.type,
      parsedBalance: parseResult.balance,
      counterpartyNumber: parseResult.counterpartyNumber,
      mentionedPhoneNumbers: parseResult.mentionedPhoneNumbers,
    );

    final explicitlyMentionedWallet = _findWalletByPhone(
      wallets,
      explicitWalletPhone,
    );

    if (explicitlyMentionedWallet != null &&
        explicitlyMentionedWallet.id != selectedWallet.id) {
      return Success(
        ManualTransactionAssessment(
          transaction: assessment.transaction,
          reviewKind: ManualTransactionReviewKind.explicitWalletMismatch,
          suggestedWallet: explicitlyMentionedWallet,
          explicitWalletPhone: explicitWalletPhone,
        ),
      );
    }

    if (explicitWalletPhone != null && explicitlyMentionedWallet == null) {
      return Success(
        ManualTransactionAssessment(
          transaction: assessment.transaction,
          reviewKind: ManualTransactionReviewKind.explicitWalletMismatch,
          explicitWalletPhone: explicitWalletPhone,
        ),
      );
    }

    final candidateWallets = wallets
        .where((wallet) => wallet.provider == selectedWallet.provider)
        .toList();

    final matchResult = SmsWalletMatcher.resolve(
      wallets: candidateWallets,
      input: input,
    );

    return switch (matchResult) {
      SmsWalletMatchedResult(:final wallet)
          when wallet.id == selectedWallet.id =>
        Success(assessment),
      SmsWalletMatchedResult(:final wallet) => Success(
        ManualTransactionAssessment(
          transaction: assessment.transaction,
          reviewKind: ManualTransactionReviewKind.inferredWalletMismatch,
          suggestedWallet: wallet,
        ),
      ),
      SmsWalletNoCandidate() => Success(
        ManualTransactionAssessment(
          transaction: assessment.transaction,
          reviewKind: ManualTransactionReviewKind.needsConfirmation,
        ),
      ),
      SmsWalletDefiniteMiss() => Success(
        ManualTransactionAssessment(
          transaction: assessment.transaction,
          reviewKind: ManualTransactionReviewKind.explicitWalletMismatch,
          explicitWalletPhone: explicitWalletPhone,
        ),
      ),
    };
  }

  TransactionEntity _buildTransactionEntity({
    required SmsParseResult result,
    required WalletEntity wallet,
    required String rawMessage,
  }) {
    final deterministicId = _uuid.v5(
      Namespace.url.value,
      '${result.provider}_${rawMessage.trim()}_${result.createdAt.millisecondsSinceEpoch}_${wallet.id}',
    );

    return TransactionEntity(
      id: deterministicId,
      type: result.type,
      amount: result.amount,
      createdAt: result.createdAt,
      walletId: wallet.id,
      walletOwnerUid: wallet.ownerUid,
      provider: result.provider,
      phoneNumber: wallet.phoneNumber,
      counterpartyNumber: result.counterpartyNumber,
      referenceNumber: result.referenceNumber,
      isPaid: null,
      message: rawMessage,
      statusBalance: result.balance,
    );
  }

  WalletEntity? _findWalletById(List<WalletEntity> wallets, String walletId) {
    for (final wallet in wallets) {
      if (wallet.id == walletId) return wallet;
    }
    return null;
  }

  WalletEntity? _findWalletByPhone(
    List<WalletEntity> wallets,
    String? phoneNumber,
  ) {
    if (phoneNumber == null) return null;
    final normalizedPhone = EgyptianPhoneNumber.normalize(phoneNumber);

    for (final wallet in wallets) {
      final normalizedWalletPhone = EgyptianPhoneNumber.normalize(
        wallet.phoneNumber,
      );
      if (normalizedWalletPhone == normalizedPhone ||
          normalizedWalletPhone.endsWith(normalizedPhone) ||
          normalizedPhone.endsWith(normalizedWalletPhone)) {
        return wallet;
      }
    }
    return null;
  }

  String? _resolveIntendedWalletPhone(String message, String? counterparty) {
    final numbers =
        RegExp(r'01[0125]\d+')
            .allMatches(message)
            .map((m) => m.group(0)!)
            .toList();

    if (numbers.isEmpty) return null;

    final normalizedCounterparty =
        counterparty != null ? EgyptianPhoneNumber.normalize(counterparty) : null;

    for (final number in numbers) {
      final normalized = EgyptianPhoneNumber.normalize(number);
      if (normalized == normalizedCounterparty) continue;
      return normalized;
    }

    return null;
  }
}
