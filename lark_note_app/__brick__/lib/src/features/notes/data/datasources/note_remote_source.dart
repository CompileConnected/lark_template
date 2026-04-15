import '../models/note_model.dart';
{{#network_http}}import '../../../../core/network/api_client.dart';{{/network_http}}
{{#network_dio}}import '../../../../core/network/api_client.dart';{{/network_dio}}
{{#network_rhttp}}import '../../../../core/network/api_client.dart';{{/network_rhttp}}
{{#logging_logging}}import '../../../../core/logging/app_logger.dart';{{/logging_logging}}
{{#logging_logger}}import '../../../../core/logging/app_logger.dart';{{/logging_logger}}

abstract class NoteRemoteSource {
  Future<List<NoteModel>> getNotes();
  Future<NoteModel> getNoteById(String id);
  Future<NoteModel> createNote(NoteModel note);
  Future<NoteModel> updateNote(NoteModel note);
  Future<void> deleteNote(String id);
}

class NoteRemoteSourceImpl implements NoteRemoteSource {
  {{#network_http}}final ApiClient apiClient;
  NoteRemoteSourceImpl({required this.apiClient});{{/network_http}}
  {{#network_dio}}final ApiClient apiClient;
  NoteRemoteSourceImpl({required this.apiClient});{{/network_dio}}
  {{#network_rhttp}}final ApiClient apiClient;
  NoteRemoteSourceImpl({required this.apiClient});{{/network_rhttp}}
  {{^network_http}}{{^network_dio}}{{^network_rhttp}}NoteRemoteSourceImpl();{{/network_rhttp}}{{/network_dio}}{{/network_http}}

  @override
  Future<List<NoteModel>> getNotes() async {
    {{#network_http}}{{#logging_logging}}AppLogger.info('NoteRemoteSource', 'Fetching notes from API');{{/logging_logging}}{{#logging_logger}}AppLogger.info('Fetching notes from API');{{/logging_logger}}
    final response = await apiClient.get('/notes');
    final List<dynamic> jsonList = [];
    // Parse response body
    return jsonList.map((json) => NoteModel.fromJson(json as Map<String, dynamic>)).toList();{{/network_http}}
    {{#network_dio}}{{#logging_logging}}AppLogger.info('NoteRemoteSource', 'Fetching notes from API');{{/logging_logging}}{{#logging_logger}}AppLogger.info('Fetching notes from API');{{/logging_logger}}
    final response = await apiClient.get<List<dynamic>>('/notes');
    return (response.data ?? [])
        .map((json) => NoteModel.fromJson(json as Map<String, dynamic>))
        .toList();{{/network_dio}}
    {{#network_rhttp}}{{#logging_logging}}AppLogger.info('NoteRemoteSource', 'Fetching notes from API');{{/logging_logging}}{{#logging_logger}}AppLogger.info('Fetching notes from API');{{/logging_logger}}
    final response = await apiClient.get('/notes');
    final List<dynamic> jsonList = [];
    return jsonList.map((json) => NoteModel.fromJson(json as Map<String, dynamic>)).toList();{{/network_rhttp}}
    {{^network_http}}{{^network_dio}}{{^network_rhttp}}// No network client configured - return empty list
    return [];{{/network_rhttp}}{{/network_dio}}{{/network_http}}
  }

  @override
  Future<NoteModel> getNoteById(String id) async {
    {{#network_http}}final response = await apiClient.get('/notes/$id');
    return NoteModel.fromJson({});{{/network_http}}
    {{#network_dio}}final response = await apiClient.get<Map<String, dynamic>>('/notes/$id');
    return NoteModel.fromJson(response.data ?? {});{{/network_dio}}
    {{#network_rhttp}}final response = await apiClient.get('/notes/$id');
    return NoteModel.fromJson({});{{/network_rhttp}}
    {{^network_http}}{{^network_dio}}{{^network_rhttp}}throw UnimplementedError('No network client configured');{{/network_rhttp}}{{/network_dio}}{{/network_http}}
  }

  @override
  Future<NoteModel> createNote(NoteModel note) async {
    {{#network_http}}final response = await apiClient.post('/notes', body: note.toJson());
    return NoteModel.fromJson({});{{/network_http}}
    {{#network_dio}}final response = await apiClient.post<Map<String, dynamic>>(
      '/notes',
      data: note.toJson(),
    );
    return NoteModel.fromJson(response.data ?? {});{{/network_dio}}
    {{#network_rhttp}}final response = await apiClient.post('/notes', body: note.toJson().toString());
    return NoteModel.fromJson({});{{/network_rhttp}}
    {{^network_http}}{{^network_dio}}{{^network_rhttp}}throw UnimplementedError('No network client configured');{{/network_rhttp}}{{/network_dio}}{{/network_http}}
  }

  @override
  Future<NoteModel> updateNote(NoteModel note) async {
    {{#network_http}}final response = await apiClient.put('/notes/${note.id}', body: note.toJson());
    return NoteModel.fromJson({});{{/network_http}}
    {{#network_dio}}final response = await apiClient.put<Map<String, dynamic>>(
      '/notes/${note.id}',
      data: note.toJson(),
    );
    return NoteModel.fromJson(response.data ?? {});{{/network_dio}}
    {{#network_rhttp}}final response = await apiClient.put('/notes/${note.id}', body: note.toJson().toString());
    return NoteModel.fromJson({});{{/network_rhttp}}
    {{^network_http}}{{^network_dio}}{{^network_rhttp}}throw UnimplementedError('No network client configured');{{/network_rhttp}}{{/network_dio}}{{/network_http}}
  }

  @override
  Future<void> deleteNote(String id) async {
    {{#network_http}}await apiClient.delete('/notes/$id');{{/network_http}}
    {{#network_dio}}await apiClient.delete('/notes/$id');{{/network_dio}}
    {{#network_rhttp}}await apiClient.delete('/notes/$id');{{/network_rhttp}}
    {{^network_http}}{{^network_dio}}{{^network_rhttp}}throw UnimplementedError('No network client configured');{{/network_rhttp}}{{/network_dio}}{{/network_http}}
  }
}
