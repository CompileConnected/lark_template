{{#state_management_getx}}import 'package:get/get.dart';
{{#di_get_it}}import '../../../../core/di/injection.dart';{{/di_get_it}}

import '../../data/datasources/note_local_source.dart';
import '../../data/datasources/note_remote_source.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/note_repository_impl.dart';

class NotesController extends GetxController {
  {{#di_get_it}}final NoteRepository _repository = getIt<NoteRepository>();{{/di_get_it}}
  {{^di_get_it}}final NoteRepository _repository = NoteRepositoryImpl(
    remoteSource: NoteRemoteSourceImpl(),
    localSource: NoteLocalSourceImpl(),
  );{{/di_get_it}}

  final notes = <Note>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  Future<void> loadNotes() async {
    isLoading.value = true;
    error.value = '';
    try {
      final result = await _repository.getNotes();
      notes.assignAll(result);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createNote(Note note) async {
    try {
      final created = await _repository.createNote(note);
      notes.add(created);
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      final updated = await _repository.updateNote(note);
      final index = notes.indexWhere((n) => n.id == note.id);
      if (index != -1) notes[index] = updated;
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _repository.deleteNote(id);
      notes.removeWhere((n) => n.id == id);
    } catch (e) {
      error.value = e.toString();
    }
  }
}{{/state_management_getx}}
