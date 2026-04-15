{{#state_management_none}}import '../../domain/entities/note.dart';

class NotesNotifier {
  List<Note> notes = [];
  bool isLoading = false;
  String? error;
}{{/state_management_none}}
