import 'package:equatable/equatable.dart';
import 'package:mahafez_core/mahafez_core.dart';

import '../../domain/entities/note_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_history_entry_entity.dart';

enum TransactionDetailsAction {
  none,
  markingPaid,
  deletingTransaction,
  addingNote,
  editingNote,
  deletingNote,
}

final class TransactionDetailsState extends Equatable {
  const TransactionDetailsState({
    required this.transaction,
    this.notes = const [],
    this.history = const [],
    this.currentAction = TransactionDetailsAction.none,
    this.actionError,
  });

  final TransactionEntity transaction;
  final List<NoteEntity> notes;
  final List<TransactionHistoryEntryEntity> history;
  final TransactionDetailsAction currentAction;

  /// Non-null on action failure; cleared on next action start.
  final Failure? actionError;

  bool get isActing => currentAction != TransactionDetailsAction.none;

  TransactionDetailsState copyWith({
    TransactionEntity? transaction,
    List<NoteEntity>? notes,
    List<TransactionHistoryEntryEntity>? history,
    TransactionDetailsAction? currentAction,
    Object? actionError = _sentinel,
  }) => TransactionDetailsState(
    transaction: transaction ?? this.transaction,
    notes: notes ?? this.notes,
    history: history ?? this.history,
    currentAction: currentAction ?? this.currentAction,
    actionError: identical(actionError, _sentinel)
        ? this.actionError
        : actionError as Failure?,
  );

  @override
  List<Object?> get props => [
    transaction,
    notes,
    history,
    currentAction,
    actionError,
  ];
}

const Object _sentinel = Object();
