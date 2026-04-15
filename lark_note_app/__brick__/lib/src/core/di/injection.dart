{{#di_get_it}}import 'package:get_it/get_it.dart';
{{#network_http}}import '../../core/network/api_client.dart';{{/network_http}}
{{#network_dio}}import '../../core/network/api_client.dart';{{/network_dio}}
{{#network_rhttp}}import '../../core/network/api_client.dart';{{/network_rhttp}}
{{#has_network}}import '../../core/env/env_config.dart';{{/has_network}}
import '../../features/notes/data/datasources/note_local_source.dart';
import '../../features/notes/data/datasources/note_remote_source.dart';
import '../../features/notes/domain/repositories/note_repository_impl.dart';
import '../../features/notes/domain/repositories/note_repository.dart';

final getIt = GetIt.instance;

void setupInjection() {
  {{#network_http}}// Network
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: EnvConfig.apiBaseUrl),
  );{{/network_http}}
  {{#network_dio}}// Network
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: EnvConfig.apiBaseUrl),
  );{{/network_dio}}
  {{#network_rhttp}}// Network
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: EnvConfig.apiBaseUrl),
  );{{/network_rhttp}}

  // Data sources
  getIt.registerLazySingleton<NoteRemoteSource>(
    () => NoteRemoteSourceImpl({{#network_http}}apiClient: getIt<ApiClient>(){{/network_http}}{{#network_dio}}apiClient: getIt<ApiClient>(){{/network_dio}}{{#network_rhttp}}apiClient: getIt<ApiClient>(){{/network_rhttp}}),
  );
  getIt.registerLazySingleton<NoteLocalSource>(
    () => NoteLocalSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(
      remoteSource: getIt<NoteRemoteSource>(),
      localSource: getIt<NoteLocalSource>(),
    ),
  );
}{{/di_get_it}}{{#di_injectable}}import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies({String environment = Environment.prod}) async {
  await getIt.init(environment: environment);
}{{/di_injectable}}
