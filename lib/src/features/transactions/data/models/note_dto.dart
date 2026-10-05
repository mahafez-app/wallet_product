import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/note_entity.dart';

final class NoteDto extends NoteEntity {
  const NoteDto({
    required super.id,
    required super.text,
    required super.authorName,
    required super.authorUid,
    required super.createdAt,
    super.editedAt,
  });

  factory NoteDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteDto(
      id: doc.id,
      text: data['text'] as String? ?? '',
      authorName: data['authorName'] as String? ?? '',
      authorUid: data['authorUid'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
      editedAt: (data['editedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'text': text,
    'authorName': authorName,
    'authorUid': authorUid,
    'createdAt': Timestamp.fromDate(createdAt),
    'editedAt': editedAt != null ? Timestamp.fromDate(editedAt!) : null,
  };

  NoteEntity toEntity() => NoteEntity(
    id: id,
    text: text,
    authorName: authorName,
    authorUid: authorUid,
    createdAt: createdAt,
    editedAt: editedAt,
  );
}
