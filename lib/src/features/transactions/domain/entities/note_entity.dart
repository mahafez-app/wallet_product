import 'package:equatable/equatable.dart';

class NoteEntity extends Equatable {
  const NoteEntity({
    required this.id,
    required this.text,
    required this.authorName,
    required this.authorUid,
    required this.createdAt,
    this.editedAt,
  });

  final String id;
  final String text;
  final String authorName;
  final String authorUid;
  final DateTime createdAt;

  /// Non-null when the note was edited at least once.
  final DateTime? editedAt;

  bool get wasEdited => editedAt != null;

  @override
  List<Object?> get props => [
    id,
    text,
    authorName,
    authorUid,
    createdAt,
    editedAt,
  ];
}
