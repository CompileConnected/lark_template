import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) {
  final vars = context.vars;
  final logger = context.logger;

  // Handle .env file: rename env.tpl to .env if flutter_dotenv selected, otherwise delete
  final envTpl = File('env.tpl');
  if (envTpl.existsSync()) {
    if (vars['env_flutter_dotenv'] == true) {
      final content = envTpl.readAsStringSync();
      File('.env').writeAsStringSync(content);
      logger.detail('Created .env file');
    }
    envTpl.deleteSync();
  }

  // Remove conditional files that should not exist for the selected options.
  // When a mustache conditional evaluates to falsy, the file is still created
  // but with empty content. We delete these files here.
  final filesToDelete = <String, bool>{
    // Network
    'lib/src/core/network/api_client.dart': vars['network_none'] == true,
    // Storage
    'lib/src/core/storage/local_storage_service.dart': vars['storage_none'] == true,
    // Env
    'lib/src/core/env/env_config.dart': vars['env_none'] == true,
    // Logging
    'lib/src/core/logging/app_logger.dart': vars['logging_none'] == true,
    // DI
    'lib/src/core/di/injection.dart': vars['di_none'] == true,
    'lib/src/core/di/injection.config.dart': vars['di_injectable'] != true,
    // OpenAPI
    'lib/openapi_config.dart': vars['api_openapi'] != true,
    'openapi/spec.json': vars['api_openapi'] != true,
    // State management - keep only the selected one
    'lib/src/features/notes/presentation/notifiers/notes_notifier.dart':
        vars['uses_notes_notifier'] != true,
    'lib/src/features/notes/presentation/pages/notes_notifier.dart':
        vars['state_management_none'] != true,
    'lib/src/features/notes/presentation/providers/notes_provider.dart':
        vars['state_management_riverpod'] != true,
    'lib/src/features/notes/presentation/bloc/notes_bloc.dart':
        vars['state_management_bloc'] != true,
    'lib/src/features/notes/presentation/controllers/notes_controller.dart':
        vars['state_management_getx'] != true,
    'lib/src/features/notes/presentation/stores/notes_store.dart':
        vars['state_management_mobx'] != true,
    'lib/src/features/notes/presentation/signals/notes_signal.dart':
        vars['state_management_signals'] != true,
    // DB debugger
    'lib/src/features/notes/presentation/pages/db_viewer_page.dart':
        vars['db_debugger_drift_db_viewer'] != true,
  };

  for (final entry in filesToDelete.entries) {
    if (entry.value) {
      final file = File(entry.key);
      if (file.existsSync()) {
        file.deleteSync();
        logger.detail('Removed unused file: ${entry.key}');
      }
    }
  }

  // Clean up empty directories (only if they contain no files)
  void removeEmptyDirs(Directory dir) {
    if (!dir.existsSync()) return;
    for (final entity in dir.listSync().toList()) {
      if (entity is Directory) {
        removeEmptyDirs(entity);
      }
    }
    try {
      // deleteSync without recursive will only succeed if the dir is empty
      dir.deleteSync();
      logger.detail('Removed empty directory: ${dir.path}');
    } catch (_) {
      // Directory not empty, keep it
    }
  }

  final dirsToCheck = [
    'lib/src/core/network',
    'lib/src/core/storage',
    'lib/src/core/env',
    'lib/src/core/logging',
    'lib/src/core/di',
    'lib/src/features/notes/presentation/notifiers',
    'lib/src/features/notes/presentation/providers',
    'lib/src/features/notes/presentation/bloc',
    'lib/src/features/notes/presentation/controllers',
    'lib/src/features/notes/presentation/stores',
    'lib/src/features/notes/presentation/signals',
    'openapi',
  ];

  for (final dir in dirsToCheck) {
    final d = Directory(dir);
    if (d.existsSync()) {
      removeEmptyDirs(d);
    }
  }

  // Clean up platform directories for unselected platforms
  final platforms = <String, bool>{
    'android': vars['has_android'] == true,
    'ios': vars['has_ios'] == true,
    'web': vars['has_web'] == true,
    'windows': vars['has_windows'] == true,
    'macos': vars['has_macos'] == true,
    'linux': vars['has_linux'] == true,
  };

  for (final entry in platforms.entries) {
    if (!entry.value) {
      final dir = Directory(entry.key);
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
        logger.detail('Removed platform directory: ${entry.key}');
      }
    }
  }

  // Clean up blank lines in YAML files (caused by mustache conditionals)
  final yamlFiles = ['pubspec.yaml', 'analysis_options.yaml'];
  for (final path in yamlFiles) {
    final file = File(path);
    if (file.existsSync()) {
      final content = file.readAsStringSync();
      final cleaned = RegExp(r'\n{3,}').allMatches(content).fold<String>(
            content,
            (acc, match) => acc.replaceAll(match.group(0)!, '\n\n'),
          );
      file.writeAsStringSync(cleaned);
    }
  }

  // Run dart format on generated files
  final libDir = Directory('lib');
  if (libDir.existsSync()) {
    logger.info('Formatting generated Dart files...');
    Process.runSync('dart', ['format', 'lib/']);
  }

  final projectName = vars['project_name'] as String? ?? 'my_app';
  logger.info('\nGenerated $projectName successfully!');
  logger.info('Next steps:');
  logger.info('  1. cd $projectName');
  logger.info('  2. flutter pub get');
  if (vars['needs_code_generation'] == true) {
    logger.info('  3. dart run build_runner build --delete-conflicting-outputs');
  }
}
