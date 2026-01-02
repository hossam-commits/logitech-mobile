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
    AppLogger.i('Firebase initialized successfully in ${AppConfig.environment} mode');
  } catch (e, st) {
    AppLogger.e('Firebase initialize error', e, st);
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
      // لاحقاً: وفّر طريقة لتعديل الـ locale عبر Config بدلاً من الحشر هنا.
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