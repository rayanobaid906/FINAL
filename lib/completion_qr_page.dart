import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fix_it/app_colors.dart';
import 'package:fix_it/providers/order_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CompletionQrPage extends StatefulWidget {
  final int orderId;

  const CompletionQrPage({super.key, required this.orderId});

  @override
  State<CompletionQrPage> createState() => _CompletionQrPageState();
}

class _CompletionQrPageState extends State<CompletionQrPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<OrderProvider>().generateCompletionQr(widget.orderId);
    });
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
          'إنهاء الطلب',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isGeneratingCompletionQr) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orderProvider.completionQrError != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    orderProvider.completionQrError!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OrderProvider>().generateCompletionQr(
                        widget.orderId,
                      );
                    },
                    child: const Text(
                      'إعادة المحاولة',
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                  ),
                ],
              ),
            );
          }

          final qr = orderProvider.completionQr;

          if (qr == null) {
            return const Center(
              child: Text(
                'لم يتم إنشاء رمز إنهاء الطلب',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                QrImageView(
                   data: qr.token,
                  version: QrVersions.auto,
                  size: 220,
                  backgroundColor: Colors.white,
                ),

                const SizedBox(height: 24),

                const Text(
                  'اعرض هذا الرمز لمقدم الخدمة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'سيقوم مقدم الخدمة بمسح الرمز لتأكيد انتهاء الطلب.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 28),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'رمز الإنهاء',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 12),

                      SelectableText(
                        qr.token,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'ينتهي في: ${qr.expiresAt.toLocal()}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
