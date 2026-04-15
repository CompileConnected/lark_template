{{#logging_logging}}import 'package:logging/logging.dart';

class AppLogger {
  AppLogger._();

  static final _loggers = <String, Logger>{};

  static Logger get(String name) {
    return _loggers.putIfAbsent(name, () => Logger(name));
  }

  static void info(String name, String message) => get(name).info(message);
  static void warning(String name, String message) => get(name).warning(message);
  static void severe(String name, String message) => get(name).severe(message);
  static void fine(String name, String message) => get(name).fine(message);
}{{/logging_logging}}{{#logging_logger}}import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._();

  static final _logger = Logger();

  static void info(String message) => _logger.i(message);
  static void warning(String message) => _logger.w(message);
  static void error(String message, [Object? error, StackTrace? st]) =>
      _logger.e(message, error: error, stackTrace: st);
  static void debug(String message) => _logger.d(message);
}{{/logging_logger}}
