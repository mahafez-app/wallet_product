import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahafez_core/mahafez_core.dart';
import 'package:share_plus/share_plus.dart';

final shareReceiptControllerProvider =
    AsyncNotifierProvider.autoDispose<ShareReceiptController, void>(
      ShareReceiptController.new,
    );

class ShareReceiptController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  void shareReceipt({
    required Uint8List receiptBytes,
    required String fileName,
    required String shareMessage,
  }) {
    unawaited(
      _shareReceipt(
        receiptBytes: receiptBytes,
        fileName: fileName,
        shareMessage: shareMessage,
      ),
    );
  }

  Future<void> _shareReceipt({
    required Uint8List receiptBytes,
    required String fileName,
    required String shareMessage,
  }) async {
    state = const AsyncLoading();

    try {
      if (receiptBytes.isEmpty) {
        throw const UnknownFailure(
          technicalMessage: 'Failed to capture receipt image.',
        );
      }

      await SharePlus.instance.share(
        ShareParams(
          text: shareMessage,
          files: [
            XFile.fromData(receiptBytes, mimeType: 'image/png', name: fileName),
          ],
        ),
      );
      if (!ref.mounted) return;
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      final failure = UnknownFailure(technicalMessage: error.toString());
      log(
        'ShareReceiptController: $failure',
        name: 'Presentation',
        error: error,
        stackTrace: stackTrace,
      );
      if (!ref.mounted) return;
      state = AsyncError(failure, stackTrace);
    }
  }
}
