import 'package:flutter/material.dart';
import 'package:fix_it/app_colors.dart';
import 'package:qr_flutter/qr_flutter.dart'; // استيراد الحزمة المضافة

class CustomerQrScreen extends StatefulWidget {
  final String orderId; // معرف الطلب الحالي المتواجد في الـ MVP

  const CustomerQrScreen({super.key, required this.orderId});

  @override
  State<CustomerQrScreen> createState() => _CustomerQrScreenState();
}

class _CustomerQrScreenState extends State<CustomerQrScreen> {
  
  // محاكاة للـ Hash المشفر الفريد الذي يرسله الـ Backend للطلب (صفحة 16 في الـ MVP)
  // هذا الـ Hash هو ما سيتم تحويله إلى كود QR برمجياً داخل الهاتف
  final String _mockOrderHash = "FIXIT_ORDER_HASH_99214_SECURE";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "رمز إنهاء الطلب",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textPrimary, // نصوص مرئية وواضحة جداً
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              "أظهر هذا الرمز لمقدم الخدمة",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "عند قيام الفني بمسح هذا الرمز من هاتفه، سيتم تأكيد إغلاق الطلب واكتماله رسمياً في النظام لتتمكن من تقييمه.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 40),

            // 1. كارت الـ QR المولد محلياً باستخدام حزمة qr_flutter
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, // خلفية بيضاء ثابتة خلف الـ QR لضمان سهولة وسرعة مسحه بالكاميرا
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                // الـ Widget الخاص بالحزمة لتوليد الـ QR تلقائياً من النص
                child: QrImageView(
                  data: _mockOrderHash, // النص المشفر الخاص بالطلب
                  version: QrVersions.auto,
                  size: 220.0, // حجم مناسب ومريح للمسح
                  gapless: false,
                  embeddedImageStyle: const QrEmbeddedImageStyle(
                    size: Size(40, 40),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),

            // 2. مؤشر أمان وصلاحية الرمز المؤقتة (حسب متطلبات الـ MVP صفحة 16)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withOpacity(0.05)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.shield_rounded, color: Colors.amber, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "الرمز مشفر وصالح للاستخدام المؤقت",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}