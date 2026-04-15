import '../entities/note.dart';
import 'note_repository.dart';
import '../../data/datasources/note_local_source.dart';
import '../../data/datasources/note_remote_source.dart';
import '../../data/models/note_model.dart';
{{#logging_logging}}import '../../../../core/logging/app_logger.dart';{{/logging_logging}}
{{#logging_logger}}import '../../../../core/logging/app_logger.dart';{{/logging_logger}}

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteSource remoteSource;
  final NoteLocalSource localSource;

  NoteRepositoryImpl({
    required this.remoteSource,
    required this.localSource,
  });

  @override
  Future<List<Note>> getNotes() async {
    try {
      {{#logging_logging}}AppLogger.info('NoteRepository', 'Fetching notes');{{/logging_logging}}{{#logging_logger}}AppLogger.info('Fetching notes');{{/logging_logger}}
      final remoteNotes = await remoteSource.getNotes();
      await localSource.saveNotes(remoteNotes);
      return remoteNotes.map((model) => model.toEntity()).toList();
    } catch (e) {
      {{#logging_logging}}AppLogger.warning('NoteRepository', 'Remote fetch failed, falling back to local: $e');{{/logging_logging}}{{#logging_logger}}AppLogger.warning('Remote fetch failed, falling back to local: $e');{{/logging_logger}}
      final localNotes = await localSource.getNotes();
      return localNotes.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<Note> getNoteById(String id) async {
    try {
      final model = await remoteSource.getNoteById(id);
      return model.toEntity();
    } catch (_) {
      final model = await localSource.getNoteById(id);
      if (model == null) throw Exception('Note not found: $id');
      return model.toEntity();
    }
  }

  @override
  Future<Note> createNote(Note note) async {
    final model = NoteModel.fromEntity(note);
    final created = await remoteSource.createNote(model);
    await localSource.saveNote(created);
    return created.toEntity();
  }

  @override
  Future<Note> updateNote(Note note) async {
    final model = NoteModel.fromEntity(note);
    final updated = await remoteSource.updateNote(model);
    await localSource.saveNote(updated);
    return updated.toEntity();
  }

  @override
  Future<void> deleteNote(String id) async {
    await remoteSource.deleteNote(id);
    await localSource.deleteNote(id);
  }

  {{#storage_drift}}@override
  Stream<List<Note>> watchNotes() {
    return localSource.watchNotes().map(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }{{/storage_drift}}
}
