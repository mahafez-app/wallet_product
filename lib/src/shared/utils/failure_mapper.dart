import 'dart:io';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mahafez_core/mahafez_core.dart';

class FailureMapper {
  const FailureMapper();

  Failure map(Object error) => switch (error) {
    final Failure f => f,
    final FirebaseAuthException e => AuthFailure(
      code: e.code,
      technicalMessage: e.message,
    ),
    final FirebaseException e when e.code == 'unavailable' => const CacheFailure(
      technicalMessage: 'Firestore unavailable — device offline',
    ),
    final FirebaseException e when e.code == 'permission-denied' => PermissionFailure(
      code: e.code,
      technicalMessage: e.message,
    ),
    final FirebaseException e => ServerFailure(
      code: e.code,
      technicalMessage: e.message,
    ),
    final PlatformException e
        when e.code == 'firebase_firestore' &&
            (e.message?.contains('UNAVAILABLE') ?? false) =>
      NetworkFailure(technicalMessage: 'Firestore unavailable — ${e.message}'),
    final PlatformException e => UnknownFailure(technicalMessage: e.message),
    final SocketException e => NetworkFailure(technicalMessage: e.message),
    _ => UnknownFailure(technicalMessage: error.toString()),
  };
}
