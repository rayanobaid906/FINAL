import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fix_it/app_colors.dart';
import 'package:fix_it/providers/subscription_provider.dart';
import 'package:fix_it/widgets/subscription_payment_dialog.dart';
import 'package:fix_it/my_subscription_requests_page.dart';

class SubscriptionPlansPage extends StatefulWidget {
  const SubscriptionPlansPage({super.key});

  @override
  State<SubscriptionPlansPage> createState() => _SubscriptionPlansPageState();
}

class _SubscriptionPlansPageState extends State<SubscriptionPlansPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<SubscriptionProvider>().getSubscriptionPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: const Text(
          'خطط الاشتراك',
          style: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'طلباتي',
            icon: const Icon(
              Icons.receipt_long_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MySubscriptionRequestsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<SubscriptionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingPlans) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.plansError != null) {
            return Center(
              child: Text(
                provider.plansError!,
                style: const TextStyle(fontFamily: 'Cairo', color: Colors.red),
              ),
            );
          }

          if (provider.plans.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد خطط اشتراك',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.plans.length,
            itemBuilder: (context, index) {
              final plan = provider.plans[index];

              return Card(
                color: AppColors.surface,
                margin: const EdgeInsets.only(bottom: 14),
                child: ListTile(
                  title: Text(
                    plan.name,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    '${plan.price} SYP\n'
                    '${plan.durationInDays} يوم',
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => SubscriptionPaymentDialog(
                          planId: plan.id,
                          planName: plan.name,
                          price: plan.price,
                        ),
                      );
                    },
                    child: const Text(
                      'اختيار',
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
