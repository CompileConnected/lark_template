import 'package:mason/mason.dart';

void run(HookContext context) {
  final vars = Map<String, dynamic>.from(context.vars);

  // === Project Setup ===
  final projectName = vars['project_name'] as String? ?? 'my_app';
  final orgName = vars['org_name'] as String? ?? 'com.example';
  vars['dart_package_name'] = projectName.replaceAll('-', '_');

  // Platforms
  final platformAndroid = vars['platform_android'] as bool? ?? true;
  final platformIos = vars['platform_ios'] as bool? ?? true;
  final platformWeb = vars['platform_web'] as bool? ?? true;
  final platformWindows = vars['platform_windows'] as bool? ?? false;
  final platformMacos = vars['platform_macos'] as bool? ?? false;
  final platformLinux = vars['platform_linux'] as bool? ?? false;

  vars['has_android'] = platformAndroid;
  vars['has_ios'] = platformIos;
  vars['has_web'] = platformWeb;
  vars['has_windows'] = platformWindows;
  vars['has_macos'] = platformMacos;
  vars['has_linux'] = platformLinux;

  // === State Management ===
  final sm = vars['state_management'] as String? ?? 'none';
  vars['state_management_none'] = sm == 'none';
  vars['state_management_change_notifier'] = sm == 'change_notifier';
  vars['state_management_provider'] = sm == 'provider';
  vars['state_management_riverpod'] = sm == 'riverpod';
  vars['state_management_bloc'] = sm == 'bloc';
  vars['state_management_getx'] = sm == 'getx';
  vars['state_management_mobx'] = sm == 'mobx';
  vars['state_management_signals'] = sm == 'signals';

  // If Provider, Riverpod, or GetX is selected, DI is handled internally
  final diHidden = sm == 'provider' || sm == 'riverpod' || sm == 'getx';
  vars['di_hidden'] = diHidden;

  // === UI Toolkit ===
  final uiToolkit = vars['ui_toolkit'] as String? ?? 'material';
  vars['ui_toolkit_material'] = uiToolkit == 'material';
  vars['ui_toolkit_shadcn'] = uiToolkit == 'shadcn';

  // === Network Client ===
  final networkClient = vars['network_client'] as String? ?? 'none';
  vars['network_none'] = networkClient == 'none';
  vars['network_http'] = networkClient == 'http';
  vars['network_dio'] = networkClient == 'dio';
  vars['network_rhttp'] = networkClient == 'rhttp';

  // rhttp unsupported on web
  if (networkClient == 'rhttp' && platformWeb) {
    context.logger.warn('rhttp is not supported on Web. Web platform may have build issues.');
  }

  // === API Generation ===
  final apiGen = vars['api_generation'] as String? ?? 'none';
  vars['api_openapi'] = apiGen == 'openapi';

  final openapiGen = vars['openapi_generator'] as String? ?? 'dio';
  vars['openapi_dart'] = openapiGen == 'dart';
  vars['openapi_dio'] = openapiGen == 'dio';
  vars['openapi_dio_alt'] = openapiGen == 'dio_alt';

  // When OpenAPI enabled, sync network client
  if (apiGen == 'openapi') {
    if (openapiGen == 'dart') {
      vars['network_http'] = true;
      vars['network_dio'] = false;
      vars['network_rhttp'] = false;
      vars['network_none'] = false;
    } else if (openapiGen == 'dio' || openapiGen == 'dio_alt') {
      vars['network_dio'] = true;
      vars['network_http'] = false;
      vars['network_rhttp'] = false;
      vars['network_none'] = false;
    }
  }

  final openapiSpecUrl = vars['openapi_spec_url'] as String? ?? '';
  vars['openapi_spec_url'] = openapiSpecUrl;

  // === Local Storage ===
  final localStorage = vars['local_storage'] as String? ?? 'none';
  vars['storage_none'] = localStorage == 'none';
  vars['storage_shared_preferences'] = localStorage == 'shared_preferences';
  vars['storage_hive_ce'] = localStorage == 'hive_ce';
  vars['storage_isar_community'] = localStorage == 'isar_community';
  vars['storage_drift'] = localStorage == 'drift';

  // Isar and Drift unsupported on web
  if (localStorage == 'isar_community' && platformWeb) {
    context.logger.warn('Isar Community is not supported on Web. Web platform may have build issues.');
  }
  if (localStorage == 'drift' && platformWeb) {
    context.logger.warn('Drift is not supported on Web. Web platform may have build issues.');
  }

  // === Environment Config ===
  final envConfig = vars['env_config'] as String? ?? 'none';
  vars['env_none'] = envConfig == 'none';
  vars['env_flutter_dotenv'] = envConfig == 'flutter_dotenv';
  vars['env_dotenv'] = envConfig == 'dotenv';

  // === Dependency Injection (effective) ===
  final di = vars['dependency_injection'] as String? ?? 'none';
  final effectiveDI = diHidden ? 'none' : di;
  vars['di_none'] = effectiveDI == 'none';
  vars['di_get_it'] = effectiveDI == 'get_it';
  vars['di_injectable'] = effectiveDI == 'injectable';

  // === Logging ===
  final logging = vars['logging'] as String? ?? 'none';
  vars['logging_none'] = logging == 'none';
  vars['logging_logging'] = logging == 'logging';
  vars['logging_logger'] = logging == 'logger';

  // Attach logger to HTTP
  final attachLogger = vars['attach_logger_to_http'] as bool? ?? false;
  final canAttachLogger = networkClient != 'none' && logging != 'none';
  vars['attach_logger_to_http'] = canAttachLogger && attachLogger;
  vars['attach_logger_to_http_dio'] = canAttachLogger && attachLogger && networkClient == 'dio';

  // === DB Debugger ===
  final dbDebugger = vars['db_debugger'] as String? ?? 'none';
  vars['db_debugger_none'] = dbDebugger == 'none';
  vars['db_debugger_drift_db_viewer'] = dbDebugger == 'drift_db_viewer' && localStorage == 'drift';

  // === Linting ===
  final linting = vars['linting'] as String? ?? 'flutter_lints';
  vars['linting_flutter_lints'] = linting == 'flutter_lints';
  vars['linting_very_good_analysis'] = linting == 'very_good_analysis';

  // === Computed: needs code generation ===
  vars['needs_code_generation'] = sm == 'riverpod' ||
      sm == 'mobx' ||
      effectiveDI == 'injectable' ||
      localStorage == 'isar_community' ||
      localStorage == 'drift' ||
      apiGen == 'openapi';

  // === Computed: needs freezed ===
  vars['needs_freezed'] = sm == 'riverpod' || sm == 'bloc';

  // === Computed: has network ===
  vars['has_network'] = networkClient != 'none';

  // === Computed: has storage ===
  vars['has_storage'] = localStorage != 'none';

  // === Computed: uses NotesNotifier (change_notifier or provider) ===
  vars['uses_notes_notifier'] = sm == 'change_notifier' || sm == 'provider';

  context.vars = vars;
}
