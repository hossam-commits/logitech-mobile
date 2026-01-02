class AppConfig {
  static const String appTitle = String.fromEnvironment(
    'APP_TITLE',
    defaultValue: 'LogiTech Driver',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api-dev.logitech.com',
  );

  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';
}
