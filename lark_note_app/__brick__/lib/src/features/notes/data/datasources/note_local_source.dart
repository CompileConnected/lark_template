import '../models/note_model.dart';
{{#storage_shared_preferences}}import '../../../../core/storage/local_storage_service.dart';{{/storage_shared_preferences}}
{{#storage_hive_ce}}import '../../../../core/storage/local_storage_service.dart';{{/storage_hive_ce}}
{{#storage_drift}}import '../../../../core/storage/local_storage_service.dart';{{/storage_drift}}
{{#storage_isar_community}}import '../../../../core/storage/local_storage_service.dart';{{/storage_isar_community}}

abstract class NoteLocalSource {
  Future<List<NoteModel>> getNotes();
  Future<NoteModel?> getNoteById(String id);
  Future<void> saveNote(NoteModel note);
  Future<void> saveNotes(List<NoteModel> notes);
  Future<void> deleteNote(String id);
  {{#storage_drift}}Stream<List<NoteModel>> watchNotes();{{/storage_drift}}
}

class NoteLocalSourceImpl implements NoteLocalSource {
  {{#storage_drift}}final LocalStorageService _db;
  NoteLocalSourceImpl({LocalStorageService? db}) : _db = db ?? LocalStorageService();{{/storage_drift}}
  {{#storage_isar_community}}NoteLocalSourceImpl();{{/storage_isar_community}}
  {{#storage_shared_preferences}}NoteLocalSourceImpl();{{/storage_shared_preferences}}
  {{#storage_hive_ce}}NoteLocalSourceImpl();{{/storage_hive_ce}}
  {{^storage_drift}}{{^storage_isar_community}}{{^storage_shared_preferences}}{{^storage_hive_ce}}NoteLocalSourceImpl();{{/storage_hive_ce}}{{/storage_shared_preferences}}{{/storage_isar_community}}{{/storage_drift}}

  @override
  Future<List<NoteModel>> getNotes() async {
    {{#storage_drift}}final rows = await _db.getAllNotes();
    return rows.map((row) => NoteModel(
      id: row.id.toString(),
      title: row.title,
      content: row.content,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    )).toList();{{/storage_drift}}
    {{#storage_isar_community}}final isar = await Isar.getInstance();
    final notes = await isar?.noteEntitys.where().findAll() ?? [];
    return notes.map((e) => NoteModel(
      id: e.id.toString(),
      title: e.title,
      content: e.content,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    )).toList();{{/storage_isar_community}}
    {{#storage_hive_ce}}final storage = await LocalStorageService.instance;
    await storage.openBox('notes');
    final keys = storage._box.keys;
    return keys.map((key) {
      final json = storage.get(key.toString());
      if (json == null) return null;
      return NoteModel.fromJson({});
    }).whereType<NoteModel>().toList();{{/storage_hive_ce}}
    {{#storage_shared_preferences}}final storage = await LocalStorageService.instance;
    // Simple key-value: store notes as JSON string
    final notesJson = storage.getString('notes_list');
    if (notesJson == null) return [];
    return [];{{/storage_shared_preferences}}
    {{^storage_drift}}{{^storage_isar_community}}{{^storage_shared_preferences}}{{^storage_hive_ce}}// No local storage configured - return empty list
    return [];{{/storage_hive_ce}}{{/storage_shared_preferences}}{{/storage_isar_community}}{{/storage_drift}}
  }

  @override
  Future<NoteModel?> getNoteById(String id) async {
    {{#storage_drift}}final notes = await getNotes();
    try {
      return notes.firstWhere((note) => note.id == id);
    } catch (_) {
      return null;
    }{{/storage_drift}}
    {{#storage_isar_community}}final isar = await Isar.getInstance();
    final entity = await isar?.noteEntitys.get(int.parse(id));
    if (entity == null) return null;
    return NoteModel(
      id: entity.id.toString(),
      title: entity.title,
      content: entity.content,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );{{/storage_isar_community}}
    {{#storage_hive_ce}}final storage = await LocalStorageService.instance;
    await storage.openBox('notes');
    return null;{{/storage_hive_ce}}
    {{#storage_shared_preferences}}final notes = await getNotes();
    try {
      return notes.firstWhere((note) => note.id == id);
    } catch (_) {
      return null;
    }{{/storage_shared_preferences}}
    {{^storage_drift}}{{^storage_isar_community}}{{^storage_shared_preferences}}{{^storage_hive_ce}}return null;{{/storage_hive_ce}}{{/storage_shared_preferences}}{{/storage_isar_community}}{{/storage_drift}}
  }

  @override
  Future<void> saveNote(NoteModel note) async {
    {{#storage_drift}}await _db.insertNote(NoteEntitiesCompanion.insert(
      title: note.title,
      content: note.content,
    ));{{/storage_drift}}
    {{#storage_isar_community}}final isar = await Isar.getInstance();
    final entity = NoteEntity()
      ..title = note.title
      ..content = note.content
      ..createdAt = note.createdAt
      ..updatedAt = note.updatedAt;
    await isar?.noteEntitys.put(entity);{{/storage_isar_community}}
    {{#storage_hive_ce}}final storage = await LocalStorageService.instance;
    await storage.openBox('notes');
    await storage.set(note.id, note.toJson().toString());{{/storage_hive_ce}}
    {{#storage_shared_preferences}}final storage = await LocalStorageService.instance;
    // Save via shared_preferences
    await storage.setString('note_${note.id}', note.toJson().toString());{{/storage_shared_preferences}}
    {{^storage_drift}}{{^storage_isar_community}}{{^storage_shared_preferences}}{{^storage_hive_ce}}// No local storage configured{{/storage_hive_ce}}{{/storage_shared_preferences}}{{/storage_isar_community}}{{/storage_drift}}
  }

  @override
  Future<void> saveNotes(List<NoteModel> notes) async {
    for (final note in notes) {
      await saveNote(note);
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    {{#storage_drift}}await _db.deleteNote(int.parse(id));{{/storage_drift}}
    {{#storage_isar_community}}final isar = await Isar.getInstance();
    await isar?.noteEntitys.delete(int.parse(id));{{/storage_isar_community}}
    {{#storage_hive_ce}}final storage = await LocalStorageService.instance;
    await storage.openBox('notes');
    await storage.delete(id);{{/storage_hive_ce}}
    {{#storage_shared_preferences}}final storage = await LocalStorageService.instance;
    await storage.remove('note_$id');{{/storage_shared_preferences}}
    {{^storage_drift}}{{^storage_isar_community}}{{^storage_shared_preferences}}{{^storage_hive_ce}}// No local storage configured{{/storage_hive_ce}}{{/storage_shared_preferences}}{{/storage_isar_community}}{{/storage_drift}}
  }

  {{#storage_drift}}@override
  Stream<List<NoteModel>> watchNotes() {
    return _db.watchAllNotes().map((rows) => rows.map((row) => NoteModel(
      id: row.id.toString(),
      title: row.title,
      content: row.content,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    )).toList());
  }{{/storage_drift}}
}
