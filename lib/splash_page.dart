import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fix_it/app_colors.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // منطق المؤقت (Timer): ينتظر 3 ثوانٍ ثم ينتقل للشاشة التالية
    Timer(const Duration(seconds: 3), () {
      // هنا سنضع اسم شاشة الـ Login لاحقاً عندما نقوم بإنشائها
     
      // حالياً لن ننتقل لأي مكان حتى ننتهي تماماً من هذه الشاشة
      Navigator().push(context)
      print("انتهت الـ 3 ثوانٍ! جاهز للانتقال للـ Login Page");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 150,),
            Icon(
              Icons.home_repair_service_rounded,
              size: 100,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            const Text(
              "repair me ",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            // const SizedBox(height: 48),
            Spacer(flex: 2,),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }
}
