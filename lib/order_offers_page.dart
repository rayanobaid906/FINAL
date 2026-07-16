import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fix_it/app_colors.dart';
import 'package:fix_it/providers/offer_provider.dart';

class OrderOffersPage extends StatefulWidget {
  final int orderId;

  const OrderOffersPage({super.key, required this.orderId});

  @override
  State<OrderOffersPage> createState() => _OrderOffersPageState();
}

class _OrderOffersPageState extends State<OrderOffersPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<OfferProvider>().getOrderOffers(widget.orderId);
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
          'عروض الطلب',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Consumer<OfferProvider>(
        builder: (context, offerProvider, child) {
          if (offerProvider.isLoadingOrderOffers) {
            return const Center(child: CircularProgressIndicator());
          }

          if (offerProvider.orderOffersError != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    offerProvider.orderOffersError!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      context.read<OfferProvider>().getOrderOffers(
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

          final offers = offerProvider.orderOffers;

          if (offers.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد عروض على هذا الطلب حتى الآن',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () {
              return offerProvider.getOrderOffers(widget.orderId);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: offers.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final offer = offers[index];

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
                        offer.providerName,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'التخصص: ${offer.specializationName}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'التقييم: ${offer.averageRating.toStringAsFixed(1)} '
                        '(${offer.ratingsCount})',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'الطلبات المكتملة: ${offer.completedOrdersCount}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'سعر المعاينة: '
                        '${offer.inspectionPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      if (offer.note != null && offer.note!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'الملاحظة: ${offer.note}',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      if (offer.status == 0)
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final success = await context
                                      .read<OfferProvider>()
                                      .acceptInspectionOffer(offer.id);

                                  if (!mounted) return;

                                  final provider = context
                                      .read<OfferProvider>();

                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'تم قبول العرض للفحص بنجاح',
                                          style: TextStyle(fontFamily: 'Cairo'),
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                    await provider.getOrderOffers(
                                      widget.orderId,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          provider.createOfferError ??
                                              'فشل قبول العرض',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text('قبول العرض للفحص'),
                              ),
                            ),

                            const SizedBox(height: 10),

                            SizedBox(
                              width: double.infinity,
                              child: Consumer<OfferProvider>(
                                builder: (context, provider, child) {
                                  return OutlinedButton.icon(
                                    icon: provider.isRejectingOffer
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(Icons.close),

                                    label: const Text(
                                      'رفض العرض',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),

                                    onPressed: provider.isRejectingOffer
                                        ? null
                                        : () async {
                                            final confirm =
                                                await showDialog<bool>(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                    title: const Text(
                                                      'رفض العرض',
                                                    ),
                                                    content: const Text(
                                                      'هل تريد رفض هذا العرض؟',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              context,
                                                              false,
                                                            ),
                                                        child: const Text('لا'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              context,
                                                              true,
                                                            ),
                                                        child: const Text(
                                                          'نعم',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );

                                            if (confirm != true) return;

                                            final success = await provider
                                                .rejectOffer(offer.id);

                                            if (!mounted) return;

                                            if (success) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text('تم رفض العرض'),
                                                ),
                                              );

                                              await provider.getOrderOffers(
                                                widget.orderId,
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    provider.rejectOfferError ??
                                                        'فشل رفض العرض',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      if (offer.status == 1)
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Consumer<OfferProvider>(
                                builder: (context, provider, child) {
                                  return ElevatedButton(
                                    onPressed: provider.isContinuingWork
                                        ? null
                                        : () async {
                                            final success = await context
                                                .read<OfferProvider>()
                                                .continueWorkOffer(offer.id);

                                            if (!mounted) return;

                                            if (success) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'تم تأكيد متابعة العمل',
                                                    style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                    ),
                                                  ),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );

                                              await context
                                                  .read<OfferProvider>()
                                                  .getOrderOffers(
                                                    widget.orderId,
                                                  );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    provider.continueWorkError ??
                                                        'فشل متابعة العمل',
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
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: provider.isContinuingWork
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            'متابعة العمل',
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 10),

                            SizedBox(
                              width: double.infinity,
                              child: Consumer<OfferProvider>(
                                builder: (context, provider, child) {
                                  return OutlinedButton(
                                    onPressed:
                                        provider.isRejectingAfterInspection
                                        ? null
                                        : () async {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (dialogContext) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'تأكيد الرفض',
                                                    style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                    ),
                                                  ),
                                                  content: const Text(
                                                    'هل أنت متأكد أنك تريد رفض العرض بعد المعاينة؟',
                                                    style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                          dialogContext,
                                                          false,
                                                        );
                                                      },
                                                      child: const Text('لا'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                          dialogContext,
                                                          true,
                                                        );
                                                      },
                                                      child: const Text(
                                                        'نعم، رفض',
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (confirm != true) return;

                                            final success = await context
                                                .read<OfferProvider>()
                                                .rejectAfterInspectionOffer(
                                                  offer.id,
                                                );

                                            if (!mounted) return;

                                            if (success) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'تم رفض العرض بعد المعاينة',
                                                    style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                    ),
                                                  ),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );

                                              await context
                                                  .read<OfferProvider>()
                                                  .getOrderOffers(
                                                    widget.orderId,
                                                  );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    provider.rejectAfterInspectionError ??
                                                        'فشل رفض العرض',
                                                    style: const TextStyle(
                                                      fontFamily: 'Cairo',
                                                    ),
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.redAccent,
                                      side: const BorderSide(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    child: provider.isRejectingAfterInspection
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            'رفض بعد المعاينة',
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
