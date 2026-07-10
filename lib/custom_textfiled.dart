import 'package:flutter/material.dart';
import 'package:fix_it/app_colors.dart';
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false, // افتراضياً النص غير مخفي
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      // تغيير لون الخط المكتوب داخل الحقل ليصبح أبيض ناصع حسب ثيم الويب
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontFamily: 'Cairo',
      ),
      decoration: InputDecoration(
        hintText: hintText,
        
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontFamily: 'Cairo',
          fontSize: 14,
        ),
        // الأيقونة الأمامية
        prefixIcon: Icon(prefixIcon, color: AppColors.textSecondary),
        // الأيقونة الخلفية (إن وجدت)
        suffixIcon: suffixIcon,
        
        // تفعيل لون الخلفية الداخلي للحقل المستوحى من الويب (#141726)
        filled: true,
        fillColor: const Color(0xFF141726),
        
        // 1. الإطار في الحالة العادية
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), // حواف 14 بكسل متطابقة مع الويب
          borderSide: const BorderSide(
            color: Color(0xFF1A1D2E), // إطار داكن غير ملحوظ
          ),
        ),
        
        // 2. الإطار عند الضغط والكتابة داخل الحقل (Focused)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primary, // يتحول للأزرق الزاهي (#2F6BFF)
            width: 1.5,
          ),
        ),
      ),
    );
  }
}