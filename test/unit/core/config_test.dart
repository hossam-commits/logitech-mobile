import 'package:flutter_test/flutter_test.dart';
import 'package:logitech_mobile/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    setUp(() {
      AppConfig.initialize(AppEnvironment.dev);
    });

    test('should have valid default values in dev', () {
      expect(AppConfig.instance.appTitle, 'LogiTech Driver');
      expect(AppConfig.instance.apiBaseUrl, 'https://api-dev.logitech.com');
      expect(AppConfig.instance.apiTimeout, 30000);
      expect(AppConfig.instance.isValid(), true);
    });

    test('should identify environment correctly', () {
      expect(AppConfig.instance.environment, AppEnvironment.dev);
      expect(AppConfig.instance.isDevelopment, true);
      expect(AppConfig.instance.isProduction, false);
    });

    test('should validate production requirements', () {
      // Remark: We explicitly pass useMockData: false here to force real validation logic
      AppConfig.initialize(AppEnvironment.prod, useMockData: false);
      
      // Remark: In production without keys, this should return false (Invalid)
      expect(AppConfig.instance.isValid(), isFalse);
    });
  });
}
