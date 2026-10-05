import 'dart:developer';

import 'package:another_telephony/telephony.dart';

import 'package:mahafez_core/mahafez_core.dart';
import 'package:sms_engine/sms_engine.dart'
    hide InboxSmsService, InboxSmsServiceImpl;

import '../../domain/entities/transaction_entity.dart';
import '../../../wallets/domain/entities/wallet_entity.dart';
import 'sms_transaction_entity_builder.dart';

abstract interface class WalletSmsInboxAdapter {
  Future<double?> getLatestBalance({
    required WalletProvider provider,
    required String targetPhoneNumber,
    required List<String> sameProviderWalletPhoneNumbers,
    Map<String, double> sameProviderWalletBalances,
  });

  Future<List<TransactionEntity>> getHistoricalTransactionEntities({
    required WalletEntity wallet,
    required List<String> sameProviderWalletPhoneNumbers,
    Map<String, double> sameProviderWalletBalances,
    DateTime? sinceDate,
  });
}

class WalletSmsInboxAdapterImpl implements WalletSmsInboxAdapter {
  const WalletSmsInboxAdapterImpl();

  @override
  Future<double?> getLatestBalance({
    required WalletProvider provider,
    required String targetPhoneNumber,
    required List<String> sameProviderWalletPhoneNumbers,
    Map<String, double> sameProviderWalletBalances = const {},
  }) async {
    final parser = SmsParserRegistry.resolveByProvider(provider);
    if (parser == null) {
      log(
        'No parser found for provider ${provider.toValue}',
        name: 'InboxSmsService',
      );
      return null;
    }

    try {
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
      final thirtyDaysAgoMs = thirtyDaysAgo.millisecondsSinceEpoch;

      final messages = await Telephony.instance.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
        filter: SmsFilter.where(SmsColumn.DATE)
            .greaterThan(thirtyDaysAgoMs.toString()),
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );

      log(
        'Queried ${messages.length} messages from inbox for provider ${provider.toValue}',
        name: 'InboxSmsService',
      );

      final filteredMessages = messages
          .where((message) {
            final address = message.address;
            if (address == null) return false;
            return parser.senderIds.any(
              (id) => id.toLowerCase() == address.toLowerCase(),
            );
          })
          .toList(growable: false);

      final records = _parseRecords(filteredMessages);
      final balance = InboxSmsHistoryMatcher.resolveLatestBalance(
        records: records,
        targetPhoneNumber: targetPhoneNumber,
        sameProviderPhoneNumbers: sameProviderWalletPhoneNumbers,
        knownWalletBalances: sameProviderWalletBalances,
      );
      if (balance != null) {
        log(
          'Found balance $balance for ${provider.toValue} in SMS history',
          name: 'InboxSmsService',
        );
        return balance;
      }
    } catch (e, st) {
      log(
        'Failed to query inbox for provider ${provider.toValue}',
        name: 'InboxSmsService',
        error: e,
        stackTrace: st,
      );
    }

    return null;
  }

  @override
  Future<List<TransactionEntity>> getHistoricalTransactionEntities({
    required WalletEntity wallet,
    required List<String> sameProviderWalletPhoneNumbers,
    Map<String, double> sameProviderWalletBalances = const {},
    DateTime? sinceDate,
  }) async {
    try {
      final matchedRecords = await _getMatchedHistoricalRecords(
        provider: wallet.provider,
        phoneNumber: wallet.phoneNumber,
        sameProviderWalletPhoneNumbers: sameProviderWalletPhoneNumbers,
        sameProviderWalletBalances: sameProviderWalletBalances,
        sinceDate: sinceDate,
      );

      return matchedRecords
          .map(
            (record) => SmsTransactionEntityBuilder.build(
              result: record.parseResult,
              walletId: wallet.id,
              walletOwnerUid: wallet.ownerUid,
              walletPhoneNumber: wallet.phoneNumber,
              rawMessage: record.body,
            ),
          )
          .toList(growable: false);
    } catch (e, st) {
      log(
        'Failed to query historical transaction entities for '
        '${wallet.provider.toValue}',
        name: 'InboxSmsService',
        error: e,
        stackTrace: st,
      );
      return const [];
    }
  }

  Future<List<ParsedInboxSmsRecord>> _getMatchedHistoricalRecords({
    required WalletProvider provider,
    required String phoneNumber,
    required List<String> sameProviderWalletPhoneNumbers,
    required Map<String, double> sameProviderWalletBalances,
    DateTime? sinceDate,
  }) async {
    final parser = SmsParserRegistry.resolveByProvider(provider);
    if (parser == null) return const [];

    final messages = await _getProviderMessages(
      provider: provider,
      senderIds: parser.senderIds,
      sinceDate: sinceDate,
    );
    final records = _parseRecords(messages, sinceDate: sinceDate);
    final matchedRecords = InboxSmsHistoryMatcher.resolveWalletHistory(
      records: records,
      targetPhoneNumber: phoneNumber,
      sameProviderPhoneNumbers: sameProviderWalletPhoneNumbers,
      knownWalletBalances: sameProviderWalletBalances,
    );

    if (matchedRecords.isNotEmpty) {
      log(
        'Recovered ${matchedRecords.length} historical SMS records for provider '
        '${provider.toValue}',
        name: 'InboxSmsService',
      );
    }

    return matchedRecords;
  }

  Future<List<SmsMessage>> _getProviderMessages({
    required WalletProvider provider,
    required List<String> senderIds,
    DateTime? sinceDate,
  }) async {
    final effectiveSinceDate =
        sinceDate ?? DateTime.now().subtract(const Duration(days: 7));
    final sinceMs = effectiveSinceDate.millisecondsSinceEpoch;
    final filter = SmsFilter.where(SmsColumn.ADDRESS).equals(senderIds.first);

    for (final id in senderIds.skip(1)) {
      filter.or(SmsColumn.ADDRESS).equals(id);
    }

    final messages = await Telephony.instance.getInboxSms(
      columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
      filter: filter.and(SmsColumn.DATE).greaterThan('$sinceMs'),
      sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
    );

    return messages
        .where((message) {
          final address = message.address;
          if (address == null) return false;
          return senderIds.any(
            (id) => id.toLowerCase() == address.toLowerCase(),
          );
        })
        .toList(growable: false);
  }

  List<ParsedInboxSmsRecord> _parseRecords(
    List<SmsMessage> messages, {
    DateTime? sinceDate,
  }) {
    final records = <ParsedInboxSmsRecord>[];

    for (final message in messages) {
      final sender = message.address;
      final body = message.body;
      if (sender == null || body == null) {
        continue;
      }

      final createdAt = _resolveMessageDate(message.date);
      if (sinceDate != null && !createdAt.isAfter(sinceDate)) {
        continue;
      }
      final parseResult = SmsParsingService.parseRaw(
        sender: sender,
        message: body,
        smsReceivedAt: createdAt,
      );
      if (parseResult == null) {
        continue;
      }

      records.add((createdAt: createdAt, body: body, parseResult: parseResult));
    }

    return records;
  }

  DateTime _resolveMessageDate(int? timestampMs) {
    if (timestampMs == null) return DateTime.now();
    return DateTime.fromMillisecondsSinceEpoch(timestampMs);
  }
}
