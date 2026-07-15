import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import 'package:fix_it/app_colors.dart';
import 'package:fix_it/location_picker_page.dart';
import 'package:fix_it/providers/offer_provider.dart';

class SubmitOfferDialog extends StatefulWidget {
  final int orderId;

  const SubmitOfferDialog({super.key, required this.orderId});

  @override
  State<SubmitOfferDialog> createState() => _SubmitOfferDialogState();
}

class _SubmitOfferDialogState extends State<SubmitOfferDialog> {
  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _noteController = TextEditingController();

  LatLng? _selectedProviderLocation;

  @override
  void dispose() {
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text(
        'تقديم عرض',
        style: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                labelText: 'سعر المعاينة',
                labelStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _noteController,
              maxLines: 3,
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                labelText: 'ملاحظة (اختياري)',
                labelStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            InkWell(
              onTap: () async {
                final result = await Navigator.push<LatLng>(
                  context,
                  MaterialPageRoute(builder: (_) => const LocationPickerPage()),
                );

                if (result != null) {
                  setState(() {
                    _selectedProviderLocation = result;
                  });
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _selectedProviderLocation == null
                            ? 'اختر موقعك على الخريطة'
                            : 'تم اختيار الموقع: '
                                  '${_selectedProviderLocation!.latitude.toStringAsFixed(5)}, '
                                  '${_selectedProviderLocation!.longitude.toStringAsFixed(5)}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
        ),

        Consumer<OfferProvider>(
          builder: (context, provider, child) {
            return ElevatedButton(
              onPressed: provider.isCreatingOffer
                  ? null
                  : () async {
                      final price = double.tryParse(
                        _priceController.text.trim(),
                      );

                      if (price == null || price <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'الرجاء إدخال سعر صحيح',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (_selectedProviderLocation == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'الرجاء اختيار موقعك',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final note = _noteController.text.trim();

                      final success = await context
                          .read<OfferProvider>()
                          .createOffer(
                            orderId: widget.orderId,
                            inspectionPrice: price,
                            note: note.isEmpty ? null : note,
                            providerLatitude:
                                _selectedProviderLocation!.latitude,
                            providerLongitude:
                                _selectedProviderLocation!.longitude,
                          );

                      if (!mounted) return;

                      if (success) {
                        Navigator.pop(context, true);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'تم إرسال العرض بنجاح',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              provider.createOfferError ?? 'فشل إرسال العرض',
                              style: const TextStyle(fontFamily: 'Cairo'),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: provider.isCreatingOffer
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'إرسال العرض',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            );
          },
        ),
      ],
    );
  }
}
