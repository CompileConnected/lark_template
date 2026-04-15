{{#env_flutter_dotenv}}import 'package:flutter_dotenv/flutter_dotenv.dart';{{/env_flutter_dotenv}}
{{#env_dotenv}}import 'package:dotenv/dotenv.dart';{{/env_dotenv}}

/// App-wide read-only environment configuration.
/// Always available regardless of env backend selection.
/// Provides a unified interface to environment variables throughout the app.
abstract final class AppEnv {
  /// The base URL for the API.
  /// Reads [API_BASE_URL] from .env when an env backend is configured,
  /// otherwise returns the default placeholder.
  static String get apiBaseUrl {
    {{#env_flutter_dotenv}}return dotenv.env['API_BASE_URL'] ?? 'https://api.example.com';{{/env_flutter_dotenv}}
    {{#env_dotenv}}return env['API_BASE_URL'] ?? 'https://api.example.com';{{/env_dotenv}}
    {{^env_flutter_dotenv}}{{^env_dotenv}}return 'https://api.example.com';{{/env_dotenv}}{{/env_flutter_dotenv}}
  }
}

