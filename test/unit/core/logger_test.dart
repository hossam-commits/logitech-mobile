import 'package:flutter_test/flutter_test.dart';
import 'package:logitech_mobile/core/logging/app_logger.dart';

void main() {
  group('AppLogger', () {
    test('should execute all logging levels without error', () {
      expect(() => AppLogger.debug('Debug message'), returnsNormally);
      expect(() => AppLogger.info('Info message'), returnsNormally);
      expect(() => AppLogger.warning('Warning message'), returnsNormally);
      expect(() => AppLogger.error('Error message'), returnsNormally);
      expect(() => AppLogger.fatal('Fatal message'), returnsNormally);
    });
    
    test('should execute structured logging methods without error', () {
      expect(() => AppLogger.logApiRequest('GET', 'https://api.test.com'), 
             returnsNormally);
      expect(() => AppLogger.logApiResponse(200, 'https://api.test.com', duration: 150), 
             returnsNormally);
      expect(() => AppLogger.logUserAction('test_action', metadata: {'key': 'value'}), 
             returnsNormally);
    });
    
    test('deprecated methods should still work', () {
      // ignore: deprecated_member_use_from_same_package
      expect(() => AppLogger.d('Old debug'), returnsNormally);
      // ignore: deprecated_member_use_from_same_package
      expect(() => AppLogger.i('Old info'), returnsNormally);
    });
  });
}
