import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fix_it/app_colors.dart';
import 'package:fix_it/providers/offer_provider.dart';
import 'package:fix_it/models/offer_model.dart';

class EditOfferDialog extends StatefulWidget {
  final OfferModel offer;

  const EditOfferDialog({
    super.key,
    required this.offer,
  });

  @override
  State<EditOfferDialog> createState() => _EditOfferDialogState();
}

class _EditOfferDialogState extends State<EditOfferDialog> {
  late TextEditingController priceController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();

    priceController = TextEditingController(
      text: widget.offer.inspectionPrice.toString(),
    );

    noteController = TextEditingController(
      text: widget.offer.note ?? '',
    );
  }

  @override
  void dispose() {
    priceController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'تعديل العرض',
        style: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'سعر المعاينة',
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: noteController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'الملاحظة',
            ),
          ),
        ],
      ),

      actions: [

        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'إلغاء',
            style: TextStyle(
              fontFamily: 'Cairo',
            ),
          ),
        ),

        Consumer<OfferProvider>(
          builder: (context, provider, child) {

            return ElevatedButton(
              onPressed: provider.isUpdatingOffer
                  ? null
                  : () async {

                      final success =
                          await provider.updateOffer(
                        offerId: widget.offer.id,
                        inspectionPrice:
                            double.parse(
                              priceController.text,
                            ),
                        note:
                            noteController.text,
                        providerLatitude:
                            widget.offer.providerLatitude,
                        providerLongitude:
                            widget.offer.providerLongitude,
                      );


                      if (!mounted) return;


                      if (success) {

                        Navigator.pop(
                          context,
                          true,
                        );

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'تم تعديل العرض بنجاح',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                              ),
                            ),
                            backgroundColor:
                                Colors.green,
                          ),
                        );

                      } else {

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              provider
                                  .updateOfferError ??
                                  'فشل تعديل العرض',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                              ),
                            ),
                            backgroundColor:
                                Colors.red,
                          ),
                        );
                      }
                    },

              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.primary,
                foregroundColor:
                    Colors.white,
              ),

              child: provider.isUpdatingOffer
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'حفظ',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
            );
          },
        ),
      ],
    );
  }
}