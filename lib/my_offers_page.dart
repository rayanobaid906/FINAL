import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fix_it/app_colors.dart';
import 'package:fix_it/providers/offer_provider.dart';
import 'package:fix_it/widgets/edit_offer_dialog.dart';

class MyOffersPage extends StatefulWidget {
  const MyOffersPage({super.key});

  @override
  State<MyOffersPage> createState() => _MyOffersPageState();
}

class _MyOffersPageState extends State<MyOffersPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<OfferProvider>().getMyOffers();
    });
  }

  String _statusText(int status) {
    switch (status) {
      case 0:
        return 'قيد الانتظار';
      case 1:
        return 'مقبول للفحص';
      case 2:
        return 'مرفوض';
      case 3:
        return 'ملغي';
      default:
        return 'الحالة: $status';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OfferProvider>(
      builder: (context, offerProvider, child) {
        if (offerProvider.isLoadingMyOffers) {
          return const Center(child: CircularProgressIndicator());
        }

        if (offerProvider.myOffersError != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  offerProvider.myOffersError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    context.read<OfferProvider>().getMyOffers();
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

        final offers = offerProvider.myOffers;

        if (offers.isEmpty) {
          return const Center(
            child: Text(
              'لم تقدم أي عروض حتى الآن',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: offerProvider.getMyOffers,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: offers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
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
                      offer.specializationName,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      offer.orderDescription,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'سعر المعاينة: ${offer.inspectionPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (offer.note != null && offer.note!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        'الملاحظة: ${offer.note}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      _statusText(offer.status),
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    if (offer.status == 0)
                      Column(
                        children: [
                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final result = await showDialog<bool>(
                                  context: context,
                                  builder: (_) {
                                    return EditOfferDialog(offer: offer);
                                  },
                                );

                                if (result == true && context.mounted) {
                                  await context
                                      .read<OfferProvider>()
                                      .getMyOffers();
                                }
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text(
                                'تعديل العرض',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          SizedBox(
                            width: double.infinity,
                            child: Consumer<OfferProvider>(
                              builder: (context, provider, child) {
                                return OutlinedButton.icon(
                                  icon: const Icon(Icons.cancel_outlined),
                                  label: provider.isCancellingOffer
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'إلغاء العرض',
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                  onPressed: provider.isCancellingOffer
                                      ? null
                                      : () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (dialogContext) {
                                              return AlertDialog(
                                                title: const Text(
                                                  'إلغاء العرض',
                                                  style: TextStyle(
                                                    fontFamily: 'Cairo',
                                                  ),
                                                ),
                                                content: const Text(
                                                  'هل أنت متأكد من إلغاء هذا العرض؟',
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
                                                    child: const Text('نعم'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (confirm != true) return;

                                          final success = await context
                                              .read<OfferProvider>()
                                              .cancelOffer(offer.id);

                                          if (!mounted) return;

                                          if (success) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'تم إلغاء العرض بنجاح',
                                                  style: TextStyle(
                                                    fontFamily: 'Cairo',
                                                  ),
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );

                                            await context
                                                .read<OfferProvider>()
                                                .getMyOffers();
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  provider.cancelOfferError ??
                                                      'فشل إلغاء العرض',
                                                  style: const TextStyle(
                                                    fontFamily: 'Cairo',
                                                  ),
                                                ),
                                                backgroundColor: Colors.red,
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
