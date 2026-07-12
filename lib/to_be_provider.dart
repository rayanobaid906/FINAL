import 'package:flutter/material.dart';
import 'package:fix_it/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:fix_it/providers/order_provider.dart';
import 'package:fix_it/providers/provider_profile_provider.dart';
import 'package:fix_it/provider_main_page.dart';

class ToBeProvider extends StatefulWidget {
  const ToBeProvider({super.key});

  @override
  State<ToBeProvider> createState() => _ToBeProvider();
}

class _ToBeProvider extends State<ToBeProvider> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _bioController =
      TextEditingController(); // حقل اختياري Bio (nullable)

  // التخصصات الأربعة المعتمدة رسمياً في مستند المشروع (صفحة 4)
  int? _selectedSpecializationId;
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<OrderProvider>().getSpecializations();
    });
  }

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
        padding: const EdgeInsets.all(20.0),
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
              Consumer<OrderProvider>(
                builder: (context, orderProvider, child) {
                  if (orderProvider.isLoadingSpecializations) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (orderProvider.errorMessage != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderProvider.errorMessage!,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.red,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<OrderProvider>().getSpecializations();
                          },
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    );
                  }

                  return DropdownButtonFormField<int>(
                    value: _selectedSpecializationId,
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
                    items: orderProvider.specializations.map((specialization) {
                      return DropdownMenuItem<int>(
                        value: specialization.id,
                        child: Text(
                          specialization.name,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSpecializationId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "الرجاء اختيار التخصص";
                      }

                      return null;
                    },
                  );
                },
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
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      final providerProfileProvider = context
                          .read<ProviderProfileProvider>();

                      final success = await providerProfileProvider
                          .createProviderProfile(
                            specializationId: _selectedSpecializationId!,
                            bio: _bioController.text.trim().isEmpty
                                ? null
                                : _bioController.text.trim(),
                          );

                      if (!mounted) return;

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'تم إنشاء ملف مقدم الخدمة بنجاح',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProviderMainPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              providerProfileProvider.createProfileError ??
                                  'فشل إنشاء ملف مقدم الخدمة',
                              style: const TextStyle(fontFamily: 'Cairo'),
                            ),
                            backgroundColor: Colors.red,
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
                    child: Consumer<ProviderProfileProvider>(
                      builder: (context, providerProfileProvider, child) {
                        if (providerProfileProvider.isCreatingProfile) {
                          return const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          );
                        }

                        return const Text(
                          'إنشاء الحساب المهني الآن',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
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
