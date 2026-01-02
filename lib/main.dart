import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'features/auth/presentation/screens/login_screen.dart';
import 'core/config/app_config.dart';
import 'core/logging/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    AppLogger.info(
      'Firebase initialized successfully in ${AppConfig.environment} mode',
    );
  } catch (e, st) {
    AppLogger.error('Firebase initialize error', e, st);
  }

  runApp(const ProviderScope(child: LogiTechApp()));
}

class LogiTechApp extends StatelessWidget {
  const LogiTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appTitle,
      debugShowCheckedModeBanner: !AppConfig.isProduction,
      // ظ„ط§ط­ظ‚ط§ظ‹: ظˆظپظ‘ط± ط·ط±ظٹظ‚ط© ظ„طھط¹ط¯ظٹظ„ ط§ظ„ظ€ locale ط¹ط¨ط± Config ط¨ط¯ظ„ط§ظ‹ ظ…ظ† ط§ظ„ط­ط´ط± ظ‡ظ†ط§.
      locale: const Locale('ar', 'SA'),
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        fontFamily: 'Tajawal',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
