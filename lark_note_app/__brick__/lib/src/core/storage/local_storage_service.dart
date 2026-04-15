{{#storage_shared_preferences}}import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService._();
  static LocalStorageService? _instance;

  static Future<LocalStorageService> get instance async {
    if (_instance != null) return _instance!;
    final prefs = await SharedPreferences.getInstance();
    _instance = LocalStorageService._internal(prefs);
    return _instance!;
  }

  late final SharedPreferences _prefs;

  LocalStorageService._internal(this._prefs);

  Future<bool> setString(String key, String value) => _prefs.setString(key, value);
  String? getString(String key) => _prefs.getString(key);

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  bool? getBool(String key) => _prefs.getBool(key);

  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  int? getInt(String key) => _prefs.getInt(key);

  Future<bool> remove(String key) => _prefs.remove(key);
  bool containsKey(String key) => _prefs.containsKey(key);

  Future<bool> clear() => _prefs.clear();
}{{/storage_shared_preferences}}{{#storage_hive_ce}}import 'package:hive_ce_flutter/hive_flutter.dart';

class LocalStorageService {
  LocalStorageService._();
  static LocalStorageService? _instance;

  static Future<LocalStorageService> get instance async {
    if (_instance != null) return _instance!;
    await Hive.initFlutter();
    _instance = LocalStorageService._();
    return _instance!;
  }

  late final Box<String> _box;

  Future<void> openBox(String name) async {
    _box = await Hive.openBox<String>(name);
  }

  Future<void> set(String key, String value) => _box.put(key, value);
  String? get(String key) => _box.get(key);

  Future<void> delete(String key) => _box.delete(key);
  bool containsKey(String key) => _box.containsKey(key);

  Future<void> clear() => _box.clear();
}{{/storage_hive_ce}}{{#storage_drift}}import 'package:drift/drift.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'local_storage_service.g.dart';

@DriftDatabase(tables: [NoteEntities])
class LocalStorageService extends _$LocalStorageService {
  LocalStorageService() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final db = await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      return NativeDatabase.createInBackground(db);
    });
  }

  // Notes queries
  Future<List<NoteEntity>> getAllNotes() => select(noteEntities).get();
  Stream<List<NoteEntity>> watchAllNotes() => select(noteEntities).watch();

  Future<int> insertNote(NoteEntitiesCompanion entry) =>
      into(noteEntities).insert(entry);

  Future<bool> updateNote(NoteEntitiesCompanion entry) =>
      update(noteEntities).replace(entry);

  Future<int> deleteNote(int id) =>
      (delete(noteEntities)..where((t) => t.id.equals(id))).go();
}

@DataClassName('NoteEntity')
class NoteEntities extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get content => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}{{/storage_drift}}{{#storage_isar_community}}import 'package:isar_community/isar_community.dart';
{{#state_management_riverpod}}import 'package:freezed_annotation/freezed_annotation.dart';{{/state_management_riverpod}}
{{#state_management_bloc}}import 'package:freezed_annotation/freezed_annotation.dart';{{/state_management_bloc}}
part 'local_storage_service.g.dart';

@collection
class NoteEntity {
  Id id = Isar.autoIncrement;

  late String title;
  late String content;

  late DateTime createdAt;
  late DateTime updatedAt;
}{{/storage_isar_community}}
