{{#state_management_riverpod}}import 'package:flutter_riverpod/flutter_riverpod.dart';
{{#di_get_it}}import '../../../../core/di/injection.dart';{{/di_get_it}}

import '../../data/datasources/note_local_source.dart';
import '../../data/datasources/note_remote_source.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/note_repository_impl.dart';

{{#di_get_it}}final noteRepositoryProvider = Provider<NoteRepository>((ref) => getIt<NoteRepository>());{{/di_get_it}}
{{^di_get_it}}final noteRepositoryProvider = Provider<NoteRepository>((ref) => NoteRepositoryImpl(
  remoteSource: NoteRemoteSourceImpl(),
  localSource: NoteLocalSourceImpl(),
));{{/di_get_it}}

final notesProvider = FutureProvider<List<Note>>((ref) async {
  final repository = ref.watch(noteRepositoryProvider);
  return repository.getNotes();
});{{/state_management_riverpod}}
