import '../entities/note.dart';

abstract class NoteRepository {
  Future<List<Note>> getNotes();
  Future<Note> getNoteById(String id);
  Future<Note> createNote(Note note);
  Future<Note> updateNote(Note note);
  Future<void> deleteNote(String id);
  {{#storage_drift}}Stream<List<Note>> watchNotes();{{/storage_drift}}
}
