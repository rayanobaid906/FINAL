import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fix_it/app_colors.dart';
import 'package:fix_it/providers/subscription_provider.dart';

class MyProviderSubscriptionsPage extends StatefulWidget {
  const MyProviderSubscriptionsPage({super.key});

  @override
  State<MyProviderSubscriptionsPage> createState() =>
      _MyProviderSubscriptionsPageState();
}

class _MyProviderSubscriptionsPageState
    extends State<MyProviderSubscriptionsPage> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<SubscriptionProvider>()
          .getMyProviderSubscriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: const Text(
          'اشتراكي الحالي',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Consumer<SubscriptionProvider>(
        builder: (context, provider, child) {

          if (provider.isLoadingMySubscriptions) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.mySubscriptionsError != null) {
            return Center(
              child: Text(
                provider.mySubscriptionsError!,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.red,
                ),
              ),
            );
          }

          if (provider.mySubscriptions.isEmpty) {
            return const Center(
              child: Text(
                'لا يوجد اشتراك فعال',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }

          final subscription =
              provider.mySubscriptions.first;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text(
                      subscription.planName,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'السعر: ${subscription.planPrice}',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.blue
                      ),
                    ),

                    Text(
                      'المدة: ${subscription.durationInDays} يوم',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.blue
                      ),
                    ),

                    Text(
                      'ينتهي في: ${subscription.endsAt}',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.blue
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'اشتراك فعال',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}