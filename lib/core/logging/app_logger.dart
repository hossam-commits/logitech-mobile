import 'package:logger/logger.dart';
import 'package:logitech_mobile/core/config/app_config.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      dateTimeFormat: DateTimeFormat.dateAndTime,
    ),
    level: AppConfig.instance.isProduction ? Level.warning : Level.debug,
  );

  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  static void logApiRequest(String method, String url) {
    _logger.i('🌐 [API Request] $method $url');
  }

  static void logApiResponse(int statusCode, String url, {int? duration}) {
    _logger.i(
      '✅ [API Response] $statusCode $url${duration != null ? ' (${duration}ms)' : ''}',
    );
  }

  static void logUserAction(String action, {Map<String, dynamic>? metadata}) {
    _logger.i(
      '👤 [User Action] $action ${metadata != null ? '- $metadata' : ''}',
    );
  }

  // Backward compatibility aliases
  @Deprecated('Use debug')
  static void d(String message, [dynamic error, StackTrace? stackTrace]) =>
      debug(message, error, stackTrace);
  @Deprecated('Use info')
  static void i(String message, [dynamic error, StackTrace? stackTrace]) =>
      info(message, error, stackTrace);
  @Deprecated('Use warning')
  static void w(String message, [dynamic error, StackTrace? stackTrace]) =>
      warning(message, error, stackTrace);
  @Deprecated('Use error')
  static void e(String message, [dynamic error, StackTrace? stackTrace]) =>
      error(message, error, stackTrace);
}
