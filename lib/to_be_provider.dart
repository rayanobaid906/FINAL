import 'package:flutter/material.dart';
import 'package:fix_it/app_colors.dart';
class ToBeProvider extends StatefulWidget {
  const ToBeProvider({super.key});

  @override
  State<ToBeProvider> createState() => _ToBeProvider();
}

class _ToBeProvider extends State<ToBeProvider> {
  final _formKey = GlobalKey<FormState>();


  String? _selectedSpecialization; // يختار تخصصاً فعالاً واحداً
  final TextEditingController _bioController =
      TextEditingController(); // حقل اختياري Bio (nullable)

  // التخصصات الأربعة المعتمدة رسمياً في مستند المشروع (صفحة 4)
  final List<String> _specializations = [
    "كهرباء",
    "سباكة",
    "أجهزة منزلية",
    "تكييف وتبريد",
  ];

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "إنشاء ملف مقدم خدمة",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textPrimary, // نص واضح ومرئي
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(200.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. عنوان حقل اختيار التخصص
              const Text(
                "اختر تخصصاً واحداً *",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              // حقل القائمة المنسدلة لاختيار التخصص (مطلوب)
              DropdownButtonFormField<String>(
                value: _selectedSpecialization,
                hint: const Text(
                  "اضغط لاختيار تخصصك المهني",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                dropdownColor: AppColors.surface,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary,
                ),
                decoration: InputDecoration(
                  fillColor: AppColors.surface,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.05),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                items: _specializations.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedSpecialization = newValue;
                  });
                },
                validator: (value) => value == null
                    ? "الرجاء اختيار التخصص المكتوب في العقد"
                    : null,
              ),

              const SizedBox(height: 24),

              // 2. عنوان حقل الـ Bio
              const Text(
            "نبذة تعريفية(اختياري)",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              
              const SizedBox(height: 8),

              // حقل النص الخاص بالـ Bio (nullable / اختياري)
              TextFormField(
                controller: _bioController,
                maxLines: 4,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText:
                      "اكتب هنا مهاراتك أو خبراتك السابقة لمشاركتها مع العملاء لاحقاً...",
                  hintStyle: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  fillColor: AppColors.surface,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.05),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                // لا يوجد فحص إلزامية (Validator) هنا لأن الحقل اختياري تماماً بحسب الـ MVP
              ),

              const SizedBox(height: 40),

              // 3. زر إنشاء الملف وتفعيل خطوة تقديم الطلب
              SizedBox(
                width: double.infinity,
                height: 54,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primary,
                        Color(0xFFC69214),
                      ], // تدرج ذهبي متناسق مع الواجهة الداكنة
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // طباعة المدخلات للتأكد من تخزينها تمهيداً لربط الـ API بالـ Backend لاحقاً
                        print("التخصص المختار: $_selectedSpecialization");
                        print(
                          "النبذة التعريفية المكتوبة: ${_bioController.text}",
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "جاري إنشاء ملف مقدم الخدمة الخاص بك...",
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "إنشاء الحساب المهني الآن",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
