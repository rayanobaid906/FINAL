import 'package:flutter/material.dart';
import 'package:fix_it/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:fix_it/providers/subscription_provider.dart';

class SubscriptionPaymentDialog extends StatefulWidget {
  final int planId;
  final String planName;
  final double price;

  const SubscriptionPaymentDialog({
    super.key,
    required this.planId,
    required this.planName,
    required this.price,
  });

  @override
  State<SubscriptionPaymentDialog> createState() =>
      _SubscriptionPaymentDialogState();
}

class _SubscriptionPaymentDialogState extends State<SubscriptionPaymentDialog> {
  final TextEditingController _transactionController = TextEditingController();

  @override
  void dispose() {
    _transactionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text(
        'طلب الاشتراك',
        style: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الخطة: ${widget.planName}',
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'السعر: ${widget.price.toStringAsFixed(0)} SYP',
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _transactionController,
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                labelText: 'رقم العملية أو الحوالة',
                labelStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.image_outlined, color: AppColors.primary),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'إضافة صورة إثبات الدفع',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
        ),
        Consumer<SubscriptionProvider>(
          builder: (context, provider, child) {
            return ElevatedButton(
              onPressed: provider.isSubmittingPaymentRequest
                  ? null
                  : () async {
                      final transactionId = _transactionController.text.trim();

                      if (transactionId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'الرجاء إدخال رقم العملية أو الحوالة',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final success = await context
                          .read<SubscriptionProvider>()
                          .submitPaymentRequest(
                            subscriptionPlanId: widget.planId,
                            transactionId: transactionId,
                            proofImageUrl: null,
                          );

                      if (!mounted) return;

                      if (success) {
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'تم إرسال طلب الاشتراك بنجاح',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              provider.submitPaymentRequestError ??
                                  'فشل إرسال طلب الاشتراك',
                              style: const TextStyle(fontFamily: 'Cairo'),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: provider.isSubmittingPaymentRequest
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'إرسال الطلب',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            );
          },
        ),
      ],
    );
  }
}
