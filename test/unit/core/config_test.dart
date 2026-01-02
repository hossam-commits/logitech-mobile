import 'package:flutter_test/flutter_test.dart';
import 'package:logitech_mobile/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('should have valid default values', () {
      expect(AppConfig.appTitle, 'LogiTech Driver');
      expect(AppConfig.apiBaseUrl, 'https://api-dev.logitech.com');
      expect(AppConfig.apiTimeout, 30000);
      expect(AppConfig.instance.isValid(), true);
    });
    
    test('should identify environment correctly', () {
      expect(AppConfig.environment, isA<String>());
      expect(AppConfig.isDevelopment || 
             AppConfig.isStaging || 
             AppConfig.isProduction, true);
    });
    
    test('should validate production requirements', () {
      // In development/test, apiKey has a default value, firebaseApiKey is empty
      if (AppConfig.isProduction) {
        // This test will only fail in real production environment if not defined
        // For testing we just check if the logic works
        expect(AppConfig.instance.isValid(), isFalse); 
      } else {
        expect(AppConfig.instance.isValid(), isTrue);
      }
    });
  });
}
