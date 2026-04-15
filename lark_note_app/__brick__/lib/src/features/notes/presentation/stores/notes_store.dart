{{#state_management_mobx}}import 'package:mobx/mobx.dart';

import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';

// part of 'notes_store.g.dart'; // Uncomment after running build_runner

class NotesStore = NotesStoreBase with _\$NotesStore;

abstract class NotesStoreBase with Store {
  final NoteRepository _repository;

  NotesStoreBase({required NoteRepository repository}) : _repository = repository;

  @observable
  List<Note> notes = [];

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @action
  Future<void> loadNotes() async {
    isLoading = true;
    error = null;
    try {
      notes = await _repository.getNotes();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> createNote(Note note) async {
    try {
      final created = await _repository.createNote(note);
      notes = [...notes, created];
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> updateNote(Note note) async {
    try {
      final updated = await _repository.updateNote(note);
      notes = notes.map((n) => n.id == updated.id ? updated : n).toList();
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> deleteNote(String id) async {
    try {
      await _repository.deleteNote(id);
      notes = notes.where((n) => n.id != id).toList();
    } catch (e) {
      error = e.toString();
    }
  }
}{{/state_management_mobx}}
