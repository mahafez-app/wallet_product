import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/transaction_entity.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'details_card_section.dart';
import 'sms_section.dart';
import 'transaction_header_section.dart';

class TransactionReceiptImage extends StatelessWidget {
  const TransactionReceiptImage({super.key, required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final horizontalContentInset = transaction.type == TransactionType.send
        ? MahafezSpacing.lg
        : 0.0;

    return Padding(
      padding: MahafezSpacing.pagePadding.copyWith(
        left: MahafezSpacing.pagePadding.left + horizontalContentInset,
        right: MahafezSpacing.pagePadding.right + horizontalContentInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: TransactionHeaderSection(transaction: transaction)),
          MahafezSpacing.lg.verticalSpace,
          DetailsCardSection(transaction: transaction, isReadOnly: true),
          if (transaction.message != null) ...[
            MahafezSpacing.xl.verticalSpace,
            SmsSection(message: transaction.message!),
          ],
          MahafezSpacing.xl.verticalSpace,
        ],
      ),
    );
  }
}
