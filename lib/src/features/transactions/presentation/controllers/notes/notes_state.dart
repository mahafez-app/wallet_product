import 'package:equatable/equatable.dart';

/// Tracks lightweight UI state local to the notes section while delegating
/// persistence to [TransactionDetailsController].
final class NotesState extends Equatable {
  const NotesState({
    this.showAddField = false,
    this.savingNoteId,
    this.isAdding = false,
    this.editingNoteId,
  });

  /// Whether the inline "add note" TextField is expanded.
  final bool showAddField;

  /// The id of the note currently being persisted via [editNote].
  /// Null when no edit save is in flight.
  final String? savingNoteId;

  /// True while [addNote] is in flight.
  final bool isAdding;

  /// The id of the note currently being edited.
  final String? editingNoteId;

  NotesState copyWith({
    bool? showAddField,
    Object? savingNoteId = _sentinel,
    bool? isAdding,
    Object? editingNoteId = _sentinel,
  }) => NotesState(
    showAddField: showAddField ?? this.showAddField,
    savingNoteId: identical(savingNoteId, _sentinel)
        ? this.savingNoteId
        : savingNoteId as String?,
    isAdding: isAdding ?? this.isAdding,
    editingNoteId: identical(editingNoteId, _sentinel)
        ? this.editingNoteId
        : editingNoteId as String?,
  );

  @override
  List<Object?> get props => [
    showAddField,
    savingNoteId,
    isAdding,
    editingNoteId,
  ];
}

const Object _sentinel = Object();
