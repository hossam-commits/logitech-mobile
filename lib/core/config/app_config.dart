import 'package:flutter/foundation.dart';

enum AppEnvironment { dev, staging, prod }

class AppConfig {
  final AppEnvironment environment;
  final String appTitle;
  final String apiBaseUrl;
  final String apiKey;
  final int apiTimeout;
  final String firebaseProjectId;
  final bool useMockData;

  AppConfig({
    required this.environment,
    required this.appTitle,
    required this.apiBaseUrl,
    required this.apiKey,
    required this.apiTimeout,
    required this.firebaseProjectId,
    required this.useMockData,
  });

  static late AppConfig _instance;
  static AppConfig get instance => _instance;

  // Remark: Added optional {bool? useMockData} to allow tests to override the environment variable.
  static void initialize(AppEnvironment env, {bool? useMockData}) {
    
    // Logic: If useMockData is passed (e.g. from tests), use it.
    // Otherwise, read from Dart environment variables.
    final effectiveMockData = useMockData ?? const bool.fromEnvironment(
      'USE_MOCK_DATA',
      defaultValue: true, // Default to mock mode for safety
    );

    _instance = AppConfig(
      environment: env,
      appTitle: const String.fromEnvironment(
        'APP_TITLE',
        defaultValue: 'LogiTech Driver',
      ),
      apiBaseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://api-dev.logitech.com',
      ),
      apiKey: const String.fromEnvironment(
        'API_KEY',
        defaultValue: 'dev_key_12345',
      ),
      apiTimeout: const int.fromEnvironment('API_TIMEOUT', defaultValue: 30000),
      firebaseProjectId: const String.fromEnvironment(
        'FIREBASE_PROJECT_ID',
      ),
      useMockData: effectiveMockData,
    );

    _instance._logConfig();
  }

  void _logConfig() {
    debugPrint('[AppConfig] Environment: $environment');
    debugPrint('[AppConfig] useMockData: $useMockData');
    if (useMockData) {
      debugPrint(
        '[AppConfig] ⚠️  MOCK MODE ACTIVE - Using mock data for demonstration',
      );
    } else {
      debugPrint(
        '[AppConfig] ✅ PRODUCTION MODE - Using live Firebase services',
      );
    }
  }

  bool get isProduction => environment == AppEnvironment.prod;
  bool get isStaging => environment == AppEnvironment.staging;
  bool get isDevelopment => environment == AppEnvironment.dev;

  bool isValid() {
    if (isProduction && !useMockData) {
      return apiKey.isNotEmpty && firebaseProjectId.isNotEmpty;
    }
    return true;
  }
}
