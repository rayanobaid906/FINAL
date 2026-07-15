import 'package:flutter/material.dart';
import 'package:fix_it/app_colors.dart'; // تأكد من صحة مسار ملف الألوان في مشروعك

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // خلفية التطبيق الداكنة الفخمة
      appBar: AppBar(
        backgroundColor: Colors.transparent, // هيدر شفاف ليندمج مع الخلفية
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "عن التطبيق",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // تأثير سحب مرن وسلس للهواتف الذكية
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // 1️⃣ قسم شعار التطبيق والإصدار (App Logo & Version)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface, // خلفية الكارت المخصصة
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.build_rounded, // أيقونة الصيانة التي ترمز لتطبيق FIXIT
                size: 70,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "FIXIT",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 28,
                fontWeight: FontWeight.bold, // خط عريض جداً للشعار
                color: AppColors.textPrimary,
                letterSpacing: 1.5,
              ),
            ),
            const Text(
              "الإصدار 1.0.0",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 30),

            // 2️⃣ قسم من نحن / نبذة عن التطبيق (About Description)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "من نحن؟",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "تطبيق FIXIT هو منصتك الموثوقة والذكية لربطك بأفضل مقدمي الخدمات المهنيين والمهندسين في مجالات الصيانة المنزلية والخدمات الفنية المختلفة. نسعى دائماً لتبسيط عملية الصيانة وجعلها أكثر أماناً، كفاءة، وسرعة بنقرة زر واحدة.",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.6, // مسافة بين الأسطر لقراءة مريحة للعين
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3️⃣ قسم ركائزنا ومميزاتنا (Key Features Grid)
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                "لماذا تختار FIXIT؟",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildFeatureRow(
              icon: Icons.verified_user_rounded,
              title: "أمان وثقة عالية",
              desc: "جميع الفنيين المسجلين لدينا يمرون بعمليات فحص وتدقيق صارمة.",
            ),
            const SizedBox(height: 12),
            _buildFeatureRow(
              icon: Icons.speed_rounded,
              title: "سرعة في التجاوب والوصول",
              desc: "خدمات صيانة طارئة وسريعة تلبي احتياجاتك في أسرع وقت ممكن.",
            ),
            const SizedBox(height: 12),
            _buildFeatureRow(
              icon: Icons.star_border_rounded,
              title: "جودة ممتازة مضمونة",
              desc: "نضمن لك جودة العمل المقدم ونتابع معك الرضا التام بعد الخدمة.",
            ),
            const SizedBox(height: 30),

            // 4️⃣ قسم روابط التواصل والدعم الفني (Contact & Social Links)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    "تواصل معنا",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildContactItem(
                    icon: Icons.email_outlined,
                    label: "الدعم الفني والبريد الإلكتروني",
                    value: "support@fixit.app",
                  ),
                  const Divider(color: Colors.white12, height: 20),
                  _buildContactItem(
                    icon: Icons.language_rounded,
                    label: "الموقع الإلكتروني",
                    value: "www.fixit.app",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 5️⃣ الحقوق وحفظ الملكية في النهاية تماماً (Copyright)
            const Text(
              "© ٢٠٢٦ جميع الحقوق محفوظة لـ FIXIT",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لبناء صف المميزات (Feature Row Helper)
  Widget _buildFeatureRow({required IconData icon, required String title, required String desc}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لبناء عناصر التواصل والتواصل الاجتماعي (Contact Item Helper)
  Widget _buildContactItem({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}