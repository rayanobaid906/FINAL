import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fix_it/app_colors.dart';
import 'package:fix_it/providers/order_provider.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<OrderProvider>().getOrderById(widget.orderId);
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
          'تفاصيل الطلب',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoadingOrderDetails) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orderProvider.orderDetailsError != null) {
            return Center(
              child: Text(
                orderProvider.orderDetailsError!,
                style: const TextStyle(fontFamily: 'Cairo', color: Colors.red),
              ),
            );
          }

          final order = orderProvider.selectedOrder;

          if (order == null) {
            return const Center(
              child: Text(
                'لا توجد تفاصيل للطلب',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.specializationName,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    order.description,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'العنوان: ${order.addressText ?? "غير محدد"}',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'رقم الطلب: ${order.id}',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'الحالة: ${order.status}',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Consumer<OrderProvider>(
                      builder: (context, orderProvider, child) {
                        return ElevatedButton(
                          onPressed: orderProvider.isCancellingOrder
                              ? null
                              : () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'تأكيد الإلغاء',
                                          style: TextStyle(fontFamily: 'Cairo'),
                                        ),
                                        content: const Text(
                                          'هل أنت متأكد أنك تريد إلغاء هذا الطلب؟',
                                          style: TextStyle(fontFamily: 'Cairo'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: const Text('لا'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                            child: const Text('نعم، إلغاء'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm != true) return;

                                  final success = await context
                                      .read<OrderProvider>()
                                      .cancelOrder(order.id);

                                  if (!context.mounted) return;

                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'تم إلغاء الطلب بنجاح',
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
                                          orderProvider.cancelOrderError ??
                                              'فشل إلغاء الطلب',
                                          style: const TextStyle(
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: orderProvider.isCancellingOrder
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'إلغاء الطلب',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
