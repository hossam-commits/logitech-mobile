import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'features/auth/presentation/screens/login_screen.dart';
import 'core/config/app_config.dart';
import 'core/logging/app_logger.dart';
import 'firebase_options.dart';

Future<void> mainCommon(AppEnvironment env) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Config
  AppConfig.initialize(env);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppLogger.info('Firebase initialized successfully in ${env.name} mode');
  } catch (e, st) {
    AppLogger.error('Firebase initialize error', e, st);
    // Firebase initialization failed - app will use fallback/mock services
  }

  runApp(const ProviderScope(child: LogiTechApp()));
}

class LogiTechApp extends StatelessWidget {
  const LogiTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.instance.appTitle,
      debugShowCheckedModeBanner: !AppConfig.instance.isProduction,
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
