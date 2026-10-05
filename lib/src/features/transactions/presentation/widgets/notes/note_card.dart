// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/utils/localization_extension.dart';
import '../../controllers/notes/notes_controller.dart';
import '../../../domain/entities/note_entity.dart';
import '../../../domain/entities/transaction_entity.dart';
import 'note_input_field.dart';
import 'note_read_view.dart';

/// A single note card that toggles between read and edit mode.
///
/// Local [StatefulWidget] owns only the [TextEditingController].
/// The boolean edit-mode flag and all Firestore mutations are delegated to
/// [NotesController].
class NoteCard extends ConsumerStatefulWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.isOwner,
    required this.transaction,
  });

  final NoteEntity note;
  final bool isOwner;
  final TransactionEntity transaction;

  @override
  ConsumerState<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends ConsumerState<NoteCard> {
  late final TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.note.text);
  }

  bool get _isEditing =>
      ref.read(notesControllerProvider(widget.transaction)).editingNoteId ==
      widget.note.id;

  @override
  void didUpdateWidget(NoteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && oldWidget.note.text != widget.note.text) {
      _editController.text = widget.note.text;
    }
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _enterEditMode() {
    _editController
      ..text = widget.note.text
      ..selection = TextSelection.collapsed(offset: widget.note.text.length);
    _notifier.enterEditMode(widget.note.id);
  }

  void _exitEditMode() => _notifier.exitEditMode();

  Future<void> _saveEdit() async {
    await _notifier.editNote(
      noteId: widget.note.id,
      text: _editController.text,
    );
  }

  Future<void> _confirmDelete() async {
    final l10n = context.l10n;
    final didConfirm = await MahafezDialog.show<bool>(
      context,
      title: l10n.transaction_deleteNoteTitle,
      message: l10n.transaction_deleteNoteMessage,
      confirmLabel: l10n.transaction_deleteAction,
      cancelLabel: MaterialLocalizations.of(context).cancelButtonLabel,
      type: MahafezDialogType.error,
      onConfirm: () => Navigator.of(context).pop(true),
      onCancel: () => Navigator.of(context).pop(false),
    );

    if (didConfirm != true || !mounted) return;
    await _notifier.deleteNote(widget.note.id);
  }

  NotesController get _notifier =>
      ref.read(notesControllerProvider(widget.transaction).notifier);

  bool get _isSaving =>
      ref.watch(notesControllerProvider(widget.transaction)).savingNoteId ==
      widget.note.id;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.mahafezColors;

    return Container(
      margin: MahafezResponsive.onlyPadding(bottom: MahafezSpacing.md),
      padding: MahafezResponsive.allPadding(MahafezSpacing.lg),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(20.responsiveRadius),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(50),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child:
          ref
                  .watch(notesControllerProvider(widget.transaction))
                  .editingNoteId ==
              widget.note.id
          ? _EditingContent(
              controller: _editController,
              isSaving: _isSaving,
              onSave: _saveEdit,
              onCancel: _exitEditMode,
            )
          : NoteReadView(
              note: widget.note,
              isOwner: widget.isOwner,
              onEditTap: _enterEditMode,
              onDeleteTap: _confirmDelete,
            ),
    );
  }
}

// ── Editing content ───────────────────────────────────────────────────────────

class _EditingContent extends StatelessWidget {
  const _EditingContent({
    super.key,
    required this.controller,
    required this.isSaving,
    required this.onSave,
    required this.onCancel,
  });

  final TextEditingController controller;
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NoteInputField(
          controller: controller,
          isBusy: isSaving,
          onSubmit: onSave,
        ),
        MahafezSpacing.xs.verticalSpace,
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton(
            onPressed: onCancel,
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
        ),
      ],
    );
  }
}
