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

  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: 'dev_key_12345',
  );

  static const int apiTimeout = int.fromEnvironment(
    'API_TIMEOUT',
    defaultValue: 30000,
  );

  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: '',
  );

  static bool get isProduction => environment == 'production';
  static bool get isStaging => environment == 'staging';
  static bool get isDevelopment => environment == 'development';

  bool isValid() {
    if (isProduction) {
      return apiKey.isNotEmpty && firebaseApiKey.isNotEmpty;
    }
    return true;
  }

  static final AppConfig instance = AppConfig._();
  AppConfig._();
}
