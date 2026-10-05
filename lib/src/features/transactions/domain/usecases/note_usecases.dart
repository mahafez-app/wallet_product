import 'package:mahafez_core/mahafez_core.dart';
import '../entities/note_entity.dart';
import '../entities/transaction_history_entry_entity.dart';
import '../repositories/transaction_repository.dart';

// ── Add note ─────────────────────────────────────────────────────────────────

final class AddNoteUseCase implements UseCase<void, AddNoteParams> {
  const AddNoteUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<void>> call(AddNoteParams params) => _repository.addNote(
    walletId: params.walletId,
    transactionId: params.transactionId,
    text: params.text,
    userId: params.userId,
    userName: params.userName,
  );
}

final class AddNoteParams {
  const AddNoteParams({
    required this.walletId,
    required this.transactionId,
    required this.text,
    required this.userId,
    required this.userName,
  });

  final String walletId;
  final String transactionId;
  final String text;
  final String userId;
  final String userName;
}

// ── Edit note ─────────────────────────────────────────────────────────────────

final class EditNoteUseCase implements UseCase<void, EditNoteParams> {
  const EditNoteUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<void>> call(EditNoteParams params) => _repository.editNote(
    walletId: params.walletId,
    transactionId: params.transactionId,
    noteId: params.noteId,
    text: params.text,
  );
}

final class EditNoteParams {
  const EditNoteParams({
    required this.walletId,
    required this.transactionId,
    required this.noteId,
    required this.text,
  });

  final String walletId;
  final String transactionId;
  final String noteId;
  final String text;
}

// ── Delete note ───────────────────────────────────────────────────────────────

final class DeleteNoteUseCase implements UseCase<void, DeleteNoteParams> {
  const DeleteNoteUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Future<Result<void>> call(DeleteNoteParams params) => _repository.deleteNote(
    walletId: params.walletId,
    transactionId: params.transactionId,
    noteId: params.noteId,
  );
}

final class DeleteNoteParams {
  const DeleteNoteParams({
    required this.walletId,
    required this.transactionId,
    required this.noteId,
  });

  final String walletId;
  final String transactionId;
  final String noteId;
}

// ── Stream notes ──────────────────────────────────────────────────────────────

final class GetNotesUseCase
    implements StreamUseCase<List<NoteEntity>, TransactionDetailsStreamParams> {
  const GetNotesUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Stream<Result<List<NoteEntity>>> call(
    TransactionDetailsStreamParams params,
  ) => _repository.getNotes(
    walletId: params.walletId,
    transactionId: params.transactionId,
  );
}

// ── Stream history ────────────────────────────────────────────────────────────

final class GetTransactionHistoryUseCase
    implements
        StreamUseCase<
          List<TransactionHistoryEntryEntity>,
          TransactionDetailsStreamParams
        > {
  const GetTransactionHistoryUseCase(this._repository);

  final TransactionRepository _repository;

  @override
  Stream<Result<List<TransactionHistoryEntryEntity>>> call(
    TransactionDetailsStreamParams params,
  ) => _repository.getTransactionHistory(
    walletId: params.walletId,
    transactionId: params.transactionId,
  );
}

final class TransactionDetailsStreamParams {
  const TransactionDetailsStreamParams({
    required this.walletId,
    required this.transactionId,
  });

  final String walletId;
  final String transactionId;
}
