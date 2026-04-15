{{#di_injectable}}// GENERATED CODE - DO NOT MODIFY BY HAND
// Run: dart run build_runner build
// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final _getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
)
Future<void> configureDependencies({String environment = Environment.prod}) async {
  await _getIt.init(environment: environment);
}
{{/di_injectable}}
