{{#state_management_bloc}}import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';

// Events
sealed class NotesEvent {}

class LoadNotes extends NotesEvent {}

class CreateNote extends NotesEvent {
  final Note note;
  CreateNote(this.note);
}

class UpdateNote extends NotesEvent {
  final Note note;
  UpdateNote(this.note);
}

class DeleteNote extends NotesEvent {
  final String id;
  DeleteNote(this.id);
}

// State
class NotesState {
  final List<Note> notes;
  final bool isLoading;
  final String? error;

  const NotesState({
    this.notes = const [],
    this.isLoading = false,
    this.error,
  });

  NotesState copyWith({
    List<Note>? notes,
    bool? isLoading,
    String? error,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Bloc
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NoteRepository repository;

  NotesBloc({required this.repository}) : super(const NotesState()) {
    on<LoadNotes>(_onLoadNotes);
    on<CreateNote>(_onCreateNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final notes = await repository.getNotes();
      emit(state.copyWith(notes: notes, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onCreateNote(CreateNote event, Emitter<NotesState> emit) async {
    try {
      final note = await repository.createNote(event.note);
      emit(state.copyWith(notes: [...state.notes, note]));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    try {
      final updated = await repository.updateNote(event.note);
      final notes = state.notes.map((n) => n.id == updated.id ? updated : n).toList();
      emit(state.copyWith(notes: notes));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    try {
      await repository.deleteNote(event.id);
      final notes = state.notes.where((n) => n.id != event.id).toList();
      emit(state.copyWith(notes: notes));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}{{/state_management_bloc}}
