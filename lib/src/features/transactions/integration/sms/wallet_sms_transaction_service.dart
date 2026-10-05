import 'dart:developer';

import 'package:another_telephony/telephony.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:sms_engine/sms_engine.dart'
    hide InboxSmsService, InboxSmsServiceImpl;

import '../../../wallets/domain/entities/wallet_entity.dart';
import '../../../wallets/domain/usecases/get_wallets_usecase.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/usecases/get_latest_transaction_date_usecase.dart';
import '../../domain/usecases/save_transaction_usecase.dart';
import 'sms_transaction_entity_builder.dart';
import 'wallet_background_sms_handler.dart';
import 'wallet_inbox_sms_service.dart';

final class WalletSmsTransactionService {
  WalletSmsTransactionService({
    required this._saveTransactionUseCase,
    required this._getLatestTransactionDateUseCase,
    required this._getWalletsUseCase,
    required this._inboxSmsService,
    required this._pendingSmsRetryService,
  });

  final SaveTransactionUseCase _saveTransactionUseCase;
  final GetLatestTransactionDateUseCase _getLatestTransactionDateUseCase;
  final GetWalletsUseCase _getWalletsUseCase;
  final WalletSmsInboxAdapter _inboxSmsService;
  final PendingSmsRetryService _pendingSmsRetryService;

  List<WalletEntity> _wallets = const [];
  bool _isListening = false;
  Future<void> _processingChain = Future<void>.value();
  bool _isReconcilingInbox = false;

  static const _tag = 'WalletSmsTransactionService';

  void updateWallets(List<WalletEntity> wallets) => _wallets = wallets;

  Future<void> startListening() async {
    await refreshWallets();
    if (_isListening) return;

    Telephony.instance.listenIncomingSms(
      onNewMessage: _handleForegroundMessage,
      onBackgroundMessage: backgroundSmsHandler,
      listenInBackground: true,
    );
    _isListening = true;
    log('SMS listener active (wallets: ${_wallets.length})', name: _tag);
  }

  Future<void> refreshWallets() async {
    final result = await _getWalletsUseCase.call();
    result.fold(
      (failure) =>
          log('Could not refresh SMS wallet candidates: $failure', name: _tag),
      (wallets) => _wallets = List.unmodifiable(wallets),
    );
  }

  Future<void> handleIncomingSms({
    required String sender,
    required String body,
    required DateTime smsReceivedAt,
  }) {
    final operation = _processingChain.then(
      (_) => _handleIncomingSmsSequentially(
        sender: sender,
        body: body,
        smsReceivedAt: smsReceivedAt,
      ),
    );
    _processingChain = operation.catchError(_logProcessingChainError);
    return operation;
  }

  Future<void> sweepRetryQueue() async {
    await _pendingSmsRetryService.retryPending(
      processItem: (item) => _processCore(
        sender: item.sender,
        body: item.body,
        smsReceivedAt: item.smsReceivedAt,
      ),
    );
  }

  Future<void> reconcileInboxHistory() {
    final operation = _processingChain.then((_) => _reconcileInboxHistory());
    _processingChain = operation.catchError(_logProcessingChainError);
    return operation;
  }

  void _handleForegroundMessage(SmsMessage message) {
    logSmsDetails(message, isBackground: false);
    final sender = message.address, body = message.body;
    if (sender == null || body == null) return;

    handleIncomingSms(
      sender: sender,
      body: body,
      smsReceivedAt: message.receivedAt,
    );
  }

  Future<bool> _processCore({
    required String sender,
    required String body,
    required DateTime smsReceivedAt,
  }) async {
    final parseResult = SmsParsingService.parseRaw(
      sender: sender,
      message: body,
      smsReceivedAt: smsReceivedAt,
    );

    if (parseResult == null) return true;

    final matchResult = _resolveWallet(
      sender: sender,
      amount: parseResult.amount,
      transactionType: parseResult.type,
      parsedBalance: parseResult.balance,
      counterpartyNumber: parseResult.counterpartyNumber,
      mentionedPhoneNumbers: parseResult.mentionedPhoneNumbers,
    );

    switch (matchResult) {
      case SmsWalletDefiniteMiss():
        // Wallet phone derived from SMS structure matches no registered wallet.
        // The transaction provably does not belong here — discard silently.
        log(
          'Definite miss: derived wallet phone matches no registered wallet. '
          'Discarding.',
          name: _tag,
        );
        return true;
      case SmsWalletNoCandidate():
        log('Wallet not found for recognized provider. Enqueuing.', name: _tag);
        _enqueueFailure(
          sender: sender,
          body: body,
          smsReceivedAt: smsReceivedAt,
          error: 'Wallet not found',
        );
        return false;
      case SmsWalletMatchedResult(:final wallet):
        final transaction = SmsTransactionEntityBuilder.build(
          result: parseResult,
          walletId: wallet.id,
          walletOwnerUid: wallet.ownerUid,
          walletPhoneNumber: wallet.phoneNumber,
          rawMessage: body,
        );
        return _save(transaction, sender: sender, body: body);
    }
  }

  SmsWalletMatchResult<WalletEntity> _resolveWallet({
    required String sender,
    double? amount,
    TransactionType? transactionType,
    double? parsedBalance,
    String? counterpartyNumber,
    List<String> mentionedPhoneNumbers = const <String>[],
  }) {
    final parser = SmsParserRegistry.resolve(sender);
    if (parser == null) return const SmsWalletNoCandidate();

    final candidates = _wallets
        .where((w) => w.provider == parser.provider)
        .toList();
    if (candidates.isEmpty) {
      log('No wallet registered for provider ${parser.provider}.', name: _tag);
      return const SmsWalletNoCandidate();
    }

    final input = SmsWalletMatchInput(
      amount: amount,
      transactionType: transactionType,
      parsedBalance: parsedBalance,
      counterpartyNumber: counterpartyNumber,
      mentionedPhoneNumbers: mentionedPhoneNumbers,
    );

    return SmsWalletMatcher.resolve(wallets: candidates, input: input);
  }

  Future<bool> _save(
    TransactionEntity transaction, {
    required String sender,
    required String body,
  }) async {
    final result = await _saveTransactionUseCase(
      SaveTransactionParams(transaction: transaction),
    );
    return result.fold(
      (failure) {
        if (failure is ValidationFailure &&
            (failure.code == 'transaction-already-exists' ||
                failure.code == 'transaction-locally-deleted')) {
          log(
            'Skipping SMS replay for transaction ${transaction.id}: '
            '${failure.code}',
            name: _tag,
          );
          return true;
        }

        log('Failed to save transaction: ${failure.runtimeType}', name: _tag);
        _enqueueFailure(
          sender: sender,
          body: body,
          smsReceivedAt: transaction.createdAt,
          walletId: transaction.walletId,
          providerName: transaction.provider.toValue,
          error: failure.toString(),
        );
        return false;
      },
      (_) {
        _updateWalletSnapshot(transaction);
        log('Transaction saved: ${transaction.id}', name: _tag);
        return true;
      },
    );
  }

  Future<void> _handleIncomingSmsSequentially({
    required String sender,
    required String body,
    required DateTime smsReceivedAt,
  }) async {
    if (await _processCore(
      sender: sender,
      body: body,
      smsReceivedAt: smsReceivedAt,
    )) {
      await sweepRetryQueue();
    }
  }

  Future<void> _reconcileInboxHistory() async {
    if (_isReconcilingInbox || _wallets.isEmpty) return;

    _isReconcilingInbox = true;
    try {
      await sweepRetryQueue();

      for (final wallet in _wallets) {
        final latestResult = await _getLatestTransactionDateUseCase(
          GetLatestTransactionDateParams(walletId: wallet.id),
        );
        final latestTransactionDate = latestResult.fold<DateTime?>(
          (_) => null,
          (date) => date,
        );

        final historicalTransactions = await _inboxSmsService
            .getHistoricalTransactionEntities(
              wallet: wallet,
              sameProviderWalletPhoneNumbers: _sameProviderWalletPhoneNumbers(
                wallet,
              ),
              sameProviderWalletBalances: _sameProviderWalletBalances(wallet),
              sinceDate: latestTransactionDate ?? wallet.createdAt,
            );

        final orderedTransactions = _newHistoricalTransactions(
          transactions: historicalTransactions,
          latestTransactionDate: latestTransactionDate,
        );

        for (final transaction in orderedTransactions) {
          final saved = await _save(
            transaction,
            sender: transaction.provider.toValue,
            body: transaction.message ?? '',
          );
          if (!saved) break;
        }
      }
    } finally {
      _isReconcilingInbox = false;
    }
  }

  List<TransactionEntity> _newHistoricalTransactions({
    required List<TransactionEntity> transactions,
    required DateTime? latestTransactionDate,
  }) {
    final filteredTransactions = latestTransactionDate == null
        ? transactions
        : transactions
              .where(
                (transaction) =>
                    transaction.createdAt.isAfter(latestTransactionDate),
              )
              .toList(growable: false);

    return filteredTransactions
      ..sort((left, right) => left.createdAt.compareTo(right.createdAt));
  }

  List<String> _sameProviderWalletPhoneNumbers(WalletEntity wallet) {
    return _wallets
        .where((candidate) => candidate.provider == wallet.provider)
        .map((candidate) => candidate.phoneNumber)
        .toSet()
        .toList(growable: false);
  }

  Map<String, double> _sameProviderWalletBalances(WalletEntity wallet) {
    final balances = <String, double>{};
    for (final candidate in _wallets) {
      if (candidate.provider != wallet.provider || candidate.id == wallet.id) {
        continue;
      }
      balances[candidate.phoneNumber] = candidate.currentBalance;
    }
    return balances;
  }

  void _updateWalletSnapshot(TransactionEntity transaction) {
    _wallets = _wallets
        .map(
          (wallet) => wallet.id == transaction.walletId
              ? WalletEntity(
                  id: wallet.id,
                  phoneNumber: wallet.phoneNumber,
                  provider: wallet.provider,
                  deviceId: wallet.deviceId,
                  ownerUid: wallet.ownerUid,
                  currentBalance:
                      transaction.statusBalance ??
                      _calculateNextBalance(wallet, transaction),
                  totalReceived:
                      wallet.totalReceived +
                      (transaction.type == TransactionType.receive
                          ? transaction.amount
                          : 0),
                  totalSent:
                      wallet.totalSent +
                      (transaction.type == TransactionType.send
                          ? transaction.amount
                          : 0),
                  lastBalanceAt:
                      transaction.createdAt.isAfter(wallet.lastBalanceAt)
                      ? transaction.createdAt
                      : wallet.lastBalanceAt,
                  createdAt: wallet.createdAt,
                  statsResetAt: wallet.statsResetAt,
                )
              : wallet,
        )
        .toList(growable: false);
  }

  double _calculateNextBalance(
    WalletEntity wallet,
    TransactionEntity transaction,
  ) {
    return transaction.type == TransactionType.receive
        ? wallet.currentBalance + transaction.amount
        : wallet.currentBalance - transaction.amount;
  }

  void _logProcessingChainError(Object error, StackTrace stackTrace) {
    log(
      'Unhandled SMS processing chain error: $error',
      name: _tag,
      stackTrace: stackTrace,
    );
  }

  void _enqueueFailure({
    required String sender,
    required String body,
    required DateTime smsReceivedAt,
    String? walletId,
    String? providerName,
    required String error,
  }) {
    final uid =
        _wallets.firstOrNull?.ownerUid ??
        FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final item = PendingSmsRetryItem.create(
      sender: sender,
      body: body,
      smsReceivedAt: smsReceivedAt,
      userUid: uid,
      walletId: walletId,
      providerName: providerName,
      error: error,
    );
    _pendingSmsRetryService.enqueue(item);
  }
}
