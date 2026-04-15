{{#env_flutter_dotenv}}import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'https://api.example.com';
  static String get(String key, {String defaultValue = ''}) =>
      dotenv.env[key] ?? defaultValue;
}{{/env_flutter_dotenv}}{{#env_dotenv}}import 'package:dotenv/dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static String get apiBaseUrl => env['API_BASE_URL'] ?? 'https://api.example.com';
  static String get(String key, {String defaultValue = ''}) =>
      env[key] ?? defaultValue;
}{{/env_dotenv}}
