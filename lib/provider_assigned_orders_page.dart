import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fix_it/app_colors.dart';
import 'package:fix_it/providers/order_provider.dart';

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
              child: ListTile(
                title: Text(
                  order.specializationName,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  order.description,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}