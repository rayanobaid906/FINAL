import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fix_it/app_colors.dart';
import 'package:fix_it/providers/order_provider.dart';
import 'package:fix_it/widgets/submit_offer_dialog.dart';

class ProviderAvailableOrdersPage extends StatefulWidget {
  const ProviderAvailableOrdersPage({super.key});

  @override
  State<ProviderAvailableOrdersPage> createState() =>
      _ProviderAvailableOrdersPageState();
}

class _ProviderAvailableOrdersPageState
    extends State<ProviderAvailableOrdersPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<OrderProvider>().getAvailableProviderOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        if (orderProvider.isLoadingAvailableProviderOrders) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orderProvider.availableProviderOrdersError != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  orderProvider.availableProviderOrdersError!,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    context.read<OrderProvider>().getAvailableProviderOrders();
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        final orders = orderProvider.availableProviderOrders;

        if (orders.isEmpty) {
          return const Center(
            child: Text(
              'لا توجد طلبات متاحة حاليًا',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: context.read<OrderProvider>().getAvailableProviderOrders,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = orders[index];

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.specializationName,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      order.description,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      order.addressText ?? 'لا يوجد عنوان',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
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
                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await showDialog<bool>(
                            context: context,
                            builder: (_) =>
                                SubmitOfferDialog(orderId: order.id),
                          );

                          if (result == true && context.mounted) {
                            await context
                                .read<OrderProvider>()
                                .getAvailableProviderOrders();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'تقديم عرض',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
