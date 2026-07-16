import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fix_it/app_colors.dart';
import 'package:fix_it/token_storage.dart';
import 'package:fix_it/login_page.dart';
import 'package:fix_it/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final TokenStorage tokenStorage = TokenStorage();

  @override
  void initState() {
    super.initState();

    checkUser();
  }

  Future<void> checkUser() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = await tokenStorage.getAccessToken();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const SizedBox(height: 150),

            Icon(
              Icons.home_repair_service_rounded,
              size: 100,
              color: AppColors.primary,
            ),

            const SizedBox(height: 24),

            const Text(
              "repair me",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const Spacer(flex: 2),

            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
