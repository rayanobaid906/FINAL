import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fix_it/app_colors.dart';
import 'package:fix_it/providers/subscription_provider.dart';

class MySubscriptionRequestsPage extends StatefulWidget {
  const MySubscriptionRequestsPage({super.key});

  @override
  State<MySubscriptionRequestsPage> createState() =>
      _MySubscriptionRequestsPageState();
}

class _MySubscriptionRequestsPageState
    extends State<MySubscriptionRequestsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<SubscriptionProvider>()
          .getMySubscriptionPaymentRequests();
    });
  }

  String _statusText(int status) {
    switch (status) {
      case 0:
        return 'قيد المراجعة';
      case 1:
        return 'مقبول';
      case 2:
        return 'مرفوض';
      default:
        return 'غير معروف';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'طلبات الاشتراك',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Consumer<SubscriptionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingMyPaymentRequests) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.myPaymentRequestsError != null) {
            return Center(
              child: Text(
                provider.myPaymentRequestsError!,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.red,
                ),
              ),
            );
          }

          if (provider.myPaymentRequests.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد طلبات اشتراك',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh:
                provider.getMySubscriptionPaymentRequests,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: provider.myPaymentRequests.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final request =
                    provider.myPaymentRequests[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.planName,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'المبلغ: ${request.amount.toStringAsFixed(0)} SYP',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'رقم العملية: ${request.transactionId}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'الحالة: ${_statusText(request.status)}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (request.adminNote != null &&
                          request.adminNote!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          'ملاحظة الإدارة: ${request.adminNote}',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}