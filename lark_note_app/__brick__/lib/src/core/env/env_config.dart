{{#env_flutter_dotenv}}import 'package:flutter_dotenv/flutter_dotenv.dart';{{/env_flutter_dotenv}}
{{#env_dotenv}}import 'package:dotenv/dotenv.dart';{{/env_dotenv}}

class EnvConfig {
  EnvConfig._();

  static String get apiBaseUrl {
    {{#env_flutter_dotenv}}return dotenv.env['API_BASE_URL'] ?? '';{{/env_flutter_dotenv}}
    {{#env_dotenv}}return env['API_BASE_URL'] ?? '';{{/env_dotenv}}
    {{^env_flutter_dotenv}}{{^env_dotenv}}return 'https://api.example.com';{{/env_dotenv}}{{/env_flutter_dotenv}}
  }

  {{#env_flutter_dotenv}}static String get(String key, {String defaultValue = ''}) =>
      dotenv.env[key] ?? defaultValue;{{/env_flutter_dotenv}}
  {{#env_dotenv}}static String get(String key, {String defaultValue = ''}) =>
      env[key] ?? defaultValue;{{/env_dotenv}}
}
