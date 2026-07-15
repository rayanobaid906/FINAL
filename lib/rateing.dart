import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fix_it/app_colors.dart';
import 'package:fix_it/providers/rating_provider.dart';

class RatingPage extends StatefulWidget {
  final int orderId;

  const RatingPage({super.key, required this.orderId});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  final _formKey = GlobalKey<FormState>();

  int _ratingValue = 0;

  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitRating() async {
    // يجب اختيار تقييم من 1 إلى 5.
    if (_ratingValue < 1 || _ratingValue > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'الرجاء اختيار تقييم من نجمة واحدة إلى خمس نجوم',
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // read يستدعي الدالة مرة واحدة، ولا يعيد بناء الصفحة.
    final ratingProvider = context.read<RatingProvider>();

    final success = await ratingProvider.createRating(
      orderId: widget.orderId,
      value: _ratingValue,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم إرسال تقييمك بنجاح، شكرًا لك',
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ratingProvider.ratingError ?? 'فشل إرسال التقييم',
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          'تقييم مقدم الخدمة',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: AppColors.textPrimary,
            size: 22,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              const Text(
                'كيف كانت تجربتك مع مقدم الخدمة؟',
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
                'تقييمك يساعدنا في الحفاظ على جودة ومصداقية الفنيين في التطبيق.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 30),

              // النجوم من 1 إلى 5.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starValue = index + 1;

                  return IconButton(
                    icon: Icon(
                      starValue <= _ratingValue
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                    ),
                    iconSize: 44,
                    color: starValue <= _ratingValue
                        ? const Color(0xFFFFB03A)
                        : AppColors.textSecondary.withValues(alpha: 0.4),
                    onPressed: () {
                      setState(() {
                        _ratingValue = starValue;
                      });
                    },
                  );
                }),
              ),

              if (_ratingValue > 0) ...[
                const SizedBox(height: 8),
                Text(
                  '$_ratingValue / 5',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],

              const SizedBox(height: 35),

              const Align(
                alignment: Alignment.topRight,
                child: Text(
                  'اكتب تعليقًا عن الخدمة (اختياري)',
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
                  hintText: 'أضف ملاحظاتك عن جودة العمل وسلوك الفني...',
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
                      color: AppColors.primary.withValues(alpha: 0.05),
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

              // Consumer يعيد بناء الزر فقط عندما تتغير حالة Provider.
              Consumer<RatingProvider>(
                builder: (context, ratingProvider, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, Color(0xFFC69214)],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ElevatedButton(
                        // نعطل الزر أثناء إرسال التقييم.
                        onPressed: ratingProvider.isSubmittingRating
                            ? null
                            : _submitRating,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          disabledBackgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: ratingProvider.isSubmittingRating
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'إرسال التقييم النهائي',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
