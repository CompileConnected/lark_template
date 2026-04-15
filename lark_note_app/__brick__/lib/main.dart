{{#ui_toolkit_material}}import 'package:flutter/material.dart';{{/ui_toolkit_material}}{{#ui_toolkit_shadcn}}import 'package:shadcn_flutter/shadcn_flutter.dart';{{/ui_toolkit_shadcn}}
{{#state_management_riverpod}}import 'package:flutter_riverpod/flutter_riverpod.dart';{{/state_management_riverpod}}
{{#state_management_provider}}import 'package:provider/provider.dart';{{/state_management_provider}}
{{#state_management_bloc}}import 'package:flutter_bloc/flutter_bloc.dart';{{/state_management_bloc}}
{{#state_management_getx}}import 'package:get/get.dart';{{/state_management_getx}}
{{#state_management_mobx}}import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';{{/state_management_mobx}}
{{#state_management_signals}}import 'package:signals_flutter/signals_flutter.dart';{{/state_management_signals}}
import 'package:go_router/go_router.dart';
{{#di_get_it}}import 'package:get_it/get_it.dart';{{/di_get_it}}
{{#di_injectable}}import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';{{/di_injectable}}
{{#env_flutter_dotenv}}import 'package:flutter_dotenv/flutter_dotenv.dart';{{/env_flutter_dotenv}}
{{#env_dotenv}}import 'package:dotenv/dotenv.dart';{{/env_dotenv}}
{{#logging_logging}}import 'package:logging/logging.dart';{{/logging_logging}}
{{#logging_logger}}import 'package:logger/logger.dart';{{/logging_logger}}
{{#db_debugger_drift_db_viewer}}import 'package:drift_db_viewer/drift_db_viewer.dart';{{/db_debugger_drift_db_viewer}}

import 'src/core/router/app_router.dart';
{{#di_get_it}}import 'src/core/di/injection.dart';{{/di_get_it}}
{{#di_injectable}}import 'src/core/di/injection.config.dart';{{/di_injectable}}
import 'src/features/notes/presentation/pages/notes_page.dart';
{{#state_management_provider}}import 'src/features/notes/presentation/notifiers/notes_notifier.dart';
import 'src/features/notes/domain/repositories/note_repository_impl.dart';
import 'src/features/notes/data/datasources/note_remote_source.dart';
import 'src/features/notes/data/datasources/note_local_source.dart';
{{#has_network}}import 'src/core/network/api_client.dart';
import 'src/core/env/app_env.dart';{{/has_network}}{{/state_management_provider}}

{{#logging_logging}}final _log = Logger('{{project_name.pascalCase()}}');{{/logging_logging}}
{{#logging_logger}}final logger = Logger();{{/logging_logger}}

{{#state_management_riverpod}}
class {{project_name.pascalCase()}} extends ConsumerWidget {
  const {{project_name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    {{#ui_toolkit_material}}return MaterialApp.router(
      title: '{{project_name}}',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routerConfig: appRouter,
    );{{/ui_toolkit_material}}
    {{#ui_toolkit_shadcn}}return ShadcnApp.router(
      title: '{{project_name}}',
      routerConfig: appRouter,
    );{{/ui_toolkit_shadcn}}
  }
}
{{/state_management_riverpod}}
{{^state_management_riverpod}}
{{#state_management_getx}}
class {{project_name.pascalCase()}} extends StatelessWidget {
  const {{project_name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      title: '{{project_name}}',
      routerDelegate: appRouter.routerDelegate,
      routeInformationParser: appRouter.routeInformationParser,
    );
  }
}
{{/state_management_getx}}
{{^state_management_getx}}
{{#state_management_provider}}
class {{project_name.pascalCase()}} extends StatelessWidget {
  const {{project_name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NotesNotifier(
            repository: NoteRepositoryImpl(
              remoteSource: NoteRemoteSourceImpl({{#has_network}}apiClient: ApiClient(baseUrl: AppEnv.apiBaseUrl){{/has_network}}),
              localSource: NoteLocalSourceImpl(),
            ),
          ),
        ),
      ],
      child: _buildApp(),
    );
  }

  Widget _buildApp() {
    {{#ui_toolkit_material}}return MaterialApp.router(
      title: '{{project_name}}',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routerConfig: appRouter,
    );{{/ui_toolkit_material}}
    {{#ui_toolkit_shadcn}}return ShadcnApp.router(
      title: '{{project_name}}',
      routerConfig: appRouter,
    );{{/ui_toolkit_shadcn}}
  }
}
{{/state_management_provider}}
{{^state_management_provider}}
class {{project_name.pascalCase()}} extends StatelessWidget {
  const {{project_name.pascalCase()}}({super.key});

  @override
  Widget build(BuildContext context) {
    {{#ui_toolkit_material}}return MaterialApp.router(
      title: '{{project_name}}',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routerConfig: appRouter,
    );{{/ui_toolkit_material}}
    {{#ui_toolkit_shadcn}}return ShadcnApp.router(
      title: '{{project_name}}',
      routerConfig: appRouter,
    );{{/ui_toolkit_shadcn}}
  }
}
{{/state_management_provider}}
{{/state_management_getx}}
{{/state_management_riverpod}}

void main() {
  {{#logging_logging}}Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });{{/logging_logging}}
  {{#logging_logger}}logger.i('Starting {{project_name}}');{{/logging_logger}}

  {{#di_get_it}}setupInjection();{{/di_get_it}}
  {{#di_injectable}}configureDependencies(environment: Environment.prod);{{/di_injectable}}

  {{#env_flutter_dotenv}}dotenv.load(fileName: '.env');{{/env_flutter_dotenv}}
  {{#env_dotenv}}load();{{/env_dotenv}}

  {{#network_rhttp}}// Note: rhttp requires async init:
  // void main() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Rhttp.init();
  //   ...
  //   runApp(const {{project_name.pascalCase()}}());
  // }{{/network_rhttp}}

  runApp(const {{project_name.pascalCase()}}());
}
