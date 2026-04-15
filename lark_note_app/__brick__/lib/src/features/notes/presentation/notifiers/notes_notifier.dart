{{#uses_notes_notifier}}import 'package:flutter/foundation.dart';
{{#di_get_it}}import '../../../../core/di/injection.dart';{{/di_get_it}}
{{#di_injectable}}import '../../../../core/di/injection.dart';{{/di_injectable}}

import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';

class NotesNotifier extends ChangeNotifier {
  {{#di_get_it}}final NoteRepository _repository = getIt<NoteRepository>();{{/di_get_it}}
  {{#di_injectable}}final NoteRepository _repository = getIt<NoteRepository>();{{/di_injectable}}
  {{^di_get_it}}{{^di_injectable}}final NoteRepository _repository;{{/di_injectable}}{{/di_get_it}}
  {{^di_get_it}}{{^di_injectable}}NotesNotifier({required NoteRepository repository}) : _repository = repository;{{/di_injectable}}{{/di_get_it}}

  List<Note> _notes = [];
  bool _isLoading = false;
  String? _error;

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadNotes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notes = await _repository.getNotes();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createNote(Note note) async {
    try {
      final created = await _repository.createNote(note);
      _notes.add(created);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      final updated = await _repository.updateNote(note);
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = updated;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _repository.deleteNote(id);
      _notes.removeWhere((n) => n.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}{{/uses_notes_notifier}}
