import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fix_it/app_colors.dart';
import 'package:fix_it/providers/order_provider.dart';
import 'package:fix_it/qr_scanner_page.dart';
class ProviderAssignedOrdersPage extends StatefulWidget {
  const ProviderAssignedOrdersPage({super.key});

  @override
  State<ProviderAssignedOrdersPage> createState() =>
      _ProviderAssignedOrdersPageState();
}

class _ProviderAssignedOrdersPageState
    extends State<ProviderAssignedOrdersPage> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<OrderProvider>()
          .getAssignedProviderOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {

        if (orderProvider.isLoadingAssignedProviderOrders) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (orderProvider.assignedProviderOrdersError != null) {
          return Center(
            child: Text(
              orderProvider.assignedProviderOrdersError!,
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: Colors.red,
              ),
            ),
          );
        }

        final orders =
            orderProvider.assignedProviderOrders;

        if (orders.isEmpty) {
          return const Center(
            child: Text(
              'لا توجد طلبات مسندة إليك',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
  color: AppColors.surface,
  margin: const EdgeInsets.only(bottom: 12),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          order.specializationName,
          style: const TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          order.description,
          style: const TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'حالة الطلب: ${order.status}',
          style: const TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.textSecondary,
          ),
        ),

        if (order.status == 3) ...[
          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QrScannerPage(
                      orderId: order.id,
                    ),
                  ),
                );

                if (result == true && context.mounted) {
                  await context
                      .read<OrderProvider>()
                      .getAssignedProviderOrders();
                }
              },
              icon: const Icon(
                Icons.qr_code_scanner_rounded,
              ),
              label: const Text(
                'مسح QR وإنهاء الطلب',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ],
    ),
  ),
);
          },
        );
      },
    );
  }
}