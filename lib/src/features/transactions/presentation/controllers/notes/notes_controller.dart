import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/transaction_entity.dart';
import '../transaction_details_controller.dart';
import 'notes_state.dart';

final notesControllerProvider = NotifierProvider.autoDispose
    .family<NotesController, NotesState, TransactionEntity>(
      NotesController.new,
    );

class NotesController extends Notifier<NotesState> {
  NotesController(this.arg);

  final TransactionEntity arg;

  @override
  NotesState build() => const NotesState();

  // ── Add field visibility ──────────────────────────────────────────────────

  void toggleAddField() =>
      state = state.copyWith(showAddField: !state.showAddField);

  void hideAddField() => state = state.copyWith(showAddField: false);

  // ── Add note ──────────────────────────────────────────────────────────────

  Future<void> addNote(String text) async {
    if (text.trim().isEmpty) return;
    state = state.copyWith(isAdding: true);

    await ref
        .read(transactionDetailsControllerProvider(arg).notifier)
        .addNote(text);

    if (!ref.mounted) return;
    if (!_lastActionSucceeded) {
      state = state.copyWith(isAdding: false);
      return;
    }

    state = state.copyWith(isAdding: false, showAddField: false);
  }

  // ── Edit note ─────────────────────────────────────────────────────────────

  void enterEditMode(String noteId) =>
      state = state.copyWith(editingNoteId: noteId);

  void exitEditMode() => state = state.copyWith(editingNoteId: null);

  Future<void> editNote({required String noteId, required String text}) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    final currentNote = ref
        .read(transactionDetailsControllerProvider(arg))
        .notes
        .where((note) => note.id == noteId)
        .firstOrNull;

    if (currentNote != null && currentNote.text.trim() == trimmedText) {
      state = state.copyWith(editingNoteId: null, savingNoteId: null);
      return;
    }

    state = state.copyWith(savingNoteId: noteId);

    await ref
        .read(transactionDetailsControllerProvider(arg).notifier)
        .editNote(noteId: noteId, text: trimmedText);

    if (!ref.mounted) return;
    if (!_lastActionSucceeded) {
      state = state.copyWith(savingNoteId: null);
      return;
    }

    state = state.copyWith(savingNoteId: null, editingNoteId: null);
  }

  // ── Delete note ───────────────────────────────────────────────────────────

  Future<void> deleteNote(String noteId) async {
    await ref
        .read(transactionDetailsControllerProvider(arg).notifier)
        .deleteNote(noteId);

    if (!ref.mounted) return;
    if (_lastActionSucceeded) {
      state = state.copyWith(editingNoteId: null, savingNoteId: null);
    }
  }

  bool get _lastActionSucceeded =>
      ref.read(transactionDetailsControllerProvider(arg)).actionError == null;
}
