import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logitech_mobile/features/dashboard/presentation/screens/main_dashboard.dart';
import 'package:logitech_mobile/core/services/providers.dart';
import 'package:logitech_mobile/core/logging/app_logger.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // طھط­ظ‚ظ‚ ظ…ظ† ط¥ط¯ط®ط§ظ„ط§طھ ط¨ط³ظٹط·ط© ظ‚ط¨ظ„ ط¨ط¯ط، ط§ظ„ط¹ظ…ظ„ظٹط©
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      // ط¹ط±ط¶ ط±ط³ط§ظ„ط© ط¨ط³ظٹط·ط© â€” ظ„ط§ط­ظ‚ط§ظ‹ ط§ط³طھط¨ط¯ظ„ظ‡ط§ ط¨ظ†ط¸ط§ظ… ط¥ط´ط¹ط§ط±ط§طھ ظ…ظˆط­ط¯ ط£ظˆ snackbar ظ…ط®طµطµ
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال البريد الإلكتروني وكلمة المرور'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.signIn(email, password);

      AppLogger.logUserAction('login', metadata: {'email': email});
      AppLogger.info('User $email logged in successfully');

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainDashboard()),
      );
    } on Exception catch (e, st) {
      AppLogger.error('Login failed for $email', e, st);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل تسجيل الدخول: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.local_shipping_rounded,
                size: 64,
                color: Color(0xFF2563EB),
              ),
              const SizedBox(height: 16),
              const Text(
                'مرحباً بك في لوجيتك',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'كلمة المرور',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: const Color(0xFF2563EB),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('تسجيل الدخول'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
