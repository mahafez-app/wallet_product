// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';
import '../../../../../shared/utils/date_extensions.dart';
import '../../../../../shared/utils/localization_extension.dart';
import '../../../domain/entities/note_entity.dart';

/// Renders a single note in read mode: text, author line, edit/delete actions.
class NoteReadView extends StatelessWidget {
  const NoteReadView({
    super.key,
    required this.note,
    required this.isOwner,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  final NoteEntity note;
  final bool isOwner;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateText = note.createdAt.toMonthDayLabel(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _NoteTextRow(
          note: note,
          isOwner: isOwner,
          onEditTap: onEditTap,
          onDeleteTap: onDeleteTap,
        ),
        MahafezSpacing.xs.verticalSpace,
        _NoteMetaRow(note: note, dateText: dateText, theme: theme),
      ],
    );
  }
}

class _NoteTextRow extends StatelessWidget {
  const _NoteTextRow({
    super.key,
    required this.note,
    required this.isOwner,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  final NoteEntity note;
  final bool isOwner;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.mahafezColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            note.text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
              height: 1.5,
            ),
          ),
        ),
        if (isOwner) ...[
          MahafezSpacing.xs.horizontalSpace,
          _ActionIconButton(
            icon: Icons.edit_outlined,
            onPressed: onEditTap,
            color: colors.info,
          ),
          _ActionIconButton(
            icon: Icons.delete_outline_rounded,
            onPressed: onDeleteTap,
            color: theme.colorScheme.error,
          ),
        ],
      ],
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      iconSize: 18.responsiveRadius,
      padding: MahafezResponsive.allPadding(8),
      constraints: const BoxConstraints(),
    );
  }
}

class _NoteMetaRow extends StatelessWidget {
  const _NoteMetaRow({
    super.key,
    required this.note,
    required this.dateText,
    required this.theme,
  });

  final NoteEntity note;
  final String dateText;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${context.l10n.transaction_by(note.authorName)} · $dateText',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withAlpha(160),
          ),
        ),
        if (note.wasEdited) ...[
          MahafezSpacing.xs.horizontalSpace,
          Text(
            context.l10n.transaction_edited,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(120),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}
