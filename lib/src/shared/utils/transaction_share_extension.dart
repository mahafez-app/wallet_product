import 'package:intl/intl.dart';

import '../../features/transactions/domain/entities/transaction_entity.dart';

extension TransactionShareExtension on TransactionEntity {
  String get receiptFileName {
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(createdAt);
    final rawName =
        'transaction_${provider.name}_${type.name}_${amount.round()}_$timestamp';

    return '${rawName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_').replaceAll(RegExp(r'_+'), '_').replaceAll(RegExp(r'^_|_$'), '')}.png';
  }
}
