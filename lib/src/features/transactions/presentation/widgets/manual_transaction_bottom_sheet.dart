import 'package:flutter/material.dart';

import 'manual_transaction_bottom_sheet_body.dart';

class ManualTransactionBottomSheet extends StatelessWidget {
  const ManualTransactionBottomSheet({super.key, required this.walletId});

  final String walletId;

  static Future<void> show(BuildContext context, {required String walletId}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ManualTransactionBottomSheet(walletId: walletId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ManualTransactionBottomSheetBody(walletId: walletId);
  }
}
