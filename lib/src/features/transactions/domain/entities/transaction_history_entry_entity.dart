import 'package:equatable/equatable.dart';

class TransactionHistoryEntryEntity extends Equatable {
  const TransactionHistoryEntryEntity({
    required this.id,
    required this.isPaid,
    required this.actorName,
    required this.actorUid,
    required this.occurredAt,
  });

  final String id;

  /// The new paid state that was set at [occurredAt].
  final bool isPaid;

  final String actorName;
  final String actorUid;
  final DateTime occurredAt;

  @override
  List<Object?> get props => [id, isPaid, actorName, actorUid, occurredAt];
}
