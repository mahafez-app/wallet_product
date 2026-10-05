import 'package:flutter/material.dart';

import 'transaction_sync_bottom_sheet_body.dart';

class TransactionSyncBottomSheet extends StatelessWidget {
  const TransactionSyncBottomSheet({super.key, required this.walletId});

  final String walletId;

  static Future<void> show(BuildContext context, {required String walletId}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) =>
          TransactionSyncBottomSheet(walletId: walletId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TransactionSyncBottomSheetBody(walletId: walletId);
  }
}
