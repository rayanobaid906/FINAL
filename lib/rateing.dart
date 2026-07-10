import 'package:flutter/material.dart';
import 'package:fix_it/app_colors.dart';
class Rateing extends StatefulWidget {
  final String orderId; // معرف الطلب المطلوب تقييمه حسب الـ MVP (صفحة 7)

  const Rateing({super.key, required this.orderId});

  @override
  State<Rateing> createState() => _RateingState();
}

class _RateingState extends State<Rateing> {
  final _formKey = GlobalKey<FormState>();

  
  int _ratingValue = 0; // القيمة الإجبارية من 1 إلى 5
  final TextEditingController _commentController =
      TextEditingController(); // حقل التعليق الاختياري (nullable)

  @override
  void dispose() {
    _commentController.dispose();
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
          "تقييم مقدم الخدمة",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textPrimary, // نص واضح ومرئي تماماً
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: AppColors.textPrimary,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: 
      SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text(
                "كيف كانت تجربتك مع مقدم الخدمة؟",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "تقييمك يساعدنا في الحفاظ على جودة ومصداقية الفنيين في التطبيق.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 30),

              // 1. صف النجوم التفاعلية الأصيل (بدون حزم خارجية)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  int starValue = index + 1;
                  return IconButton(
                    icon: Icon(
                      starValue <= _ratingValue
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                    ),
                    iconSize: 44, // حجم مريح جداً للمس والضغط باليد
                    color: starValue <= _ratingValue
                        ? const Color(0xFFFFB03A) // لون ذهبي فخم ومريح للعين
                        : AppColors.textSecondary.withOpacity(0.4),
                    onPressed: () {
                      setState(() {
                        _ratingValue = starValue; // تخزين قيمة النجمة المختارة
                      });
                    },
                  );
                }),
              ),

              // مؤشر رقمي ناعم يظهر فقط عند الاختيار
              if (_ratingValue > 0) ...[
                const SizedBox(height: 8),
                Text(
                  "$_ratingValue / 5",
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],

              const SizedBox(height: 35),

              // 2. عنوان حقل التعليق النصي
              const Align(
                alignment: Alignment.topRight,
                child: Text(
                  "اكتب تعليقاً عن الخدمة (اختياري)",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),

             
              TextFormField(
                controller: _commentController,
                maxLines: 4,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText:
                      "أضف ملاحظاتك عن جودة العمل وسلوك الفني لمساعدة المستخدمين الآخرين...",
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
              ),

              const SizedBox(height: 40),

              // 3. زر إرسال التقييم مع الـ Validator الخاص بالنجوم
              SizedBox(
                width: double.infinity,
                height: 54,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primary,
                        Color(0xFFC69214),
                      ], // تدرج ذهبي فخم
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // شرط التحقق الصارم: يجب اختيار نجمة واحدة على الأقل قبل الإرسال
                      if (_ratingValue == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "الرجاء تحديد التقييم بالنجوم أولاً قبل الإرسال.",
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      if (_formKey.currentState!.validate()) {
                        // طباعة الحقول الرسمية للتأكد من مطابقتها لجدول البيانات
                        print("OrderId: ${widget.orderId}");
                        print("Rating Value: $_ratingValue");
                        print("Comment: ${_commentController.text}");

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "تم إرسال تقييمك بنجاح، شكراً لك!",
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            backgroundColor: AppColors.primary,
                          ),
                        );

                        Navigator.pop(context); // إغلاق الشاشة والعودة تلقائياً
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
                      "إرسال التقييم النهائي",
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
