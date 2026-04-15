{{#state_management_signals}}import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';

final notesList = signal<List<Note>>([]);
final notesLoading = signal<bool>(false);
final notesError = signal<String?>(null);

late NoteRepository _notesRepository;

void initNotesSignals(NoteRepository repository) {
  _notesRepository = repository;
}

Future<void> loadNotes() async {
  notesLoading.value = true;
  notesError.value = null;
  try {
    notesList.value = await _notesRepository.getNotes();
  } catch (e) {
    notesError.value = e.toString();
  } finally {
    notesLoading.value = false;
  }
}

Future<void> createNote(Note note) async {
  try {
    final created = await _notesRepository.createNote(note);
    notesList.value = [...notesList.value, created];
  } catch (e) {
    notesError.value = e.toString();
  }
}

Future<void> updateNote(Note note) async {
  try {
    final updated = await _notesRepository.updateNote(note);
    notesList.value = notesList.value.map((n) => n.id == updated.id ? updated : n).toList();
  } catch (e) {
    notesError.value = e.toString();
  }
}

Future<void> deleteNoteSignal(String id) async {
  try {
    await _notesRepository.deleteNote(id);
    notesList.value = notesList.value.where((n) => n.id != id).toList();
  } catch (e) {
    notesError.value = e.toString();
  }
}{{/state_management_signals}}
