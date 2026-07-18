import 'package:flutter/material.dart';

import 'package:fix_it/app_colors.dart';
import 'package:fix_it/qr_scanner_page.dart';


class CameraPage extends StatelessWidget {
  const CameraPage({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.background,


      appBar: AppBar(

        backgroundColor:
            AppColors.background,

        iconTheme:
            const IconThemeData(
          color: Colors.white,
        ),

        centerTitle:
            true,

        title:
            const Text(

          'مسح رمز QR',

          style:
              TextStyle(

            fontFamily:
                'Cairo',

            color:
                AppColors.textPrimary,

            fontWeight:
                FontWeight.bold,

          ),

        ),

      ),


      body:
          Center(

        child:
            Padding(

          padding:
              const EdgeInsets.all(
            24,
          ),


          child:
              Column(

            mainAxisAlignment:
                MainAxisAlignment.center,


            children: [


              const Icon(

                Icons.qr_code_scanner_rounded,

                size:
                    100,

                color:
                    AppColors.primary,

              ),


              const SizedBox(
                height: 24,
              ),


              const Text(

                'اضغط على الزر لفتح كاميرا الهاتف',

                textAlign:
                    TextAlign.center,

                style:
                    TextStyle(

                  fontFamily:
                      'Cairo',

                  color:
                      AppColors.textPrimary,

                  fontSize:
                      16,

                ),

              ),


              const SizedBox(
                height: 30,
              ),


              SizedBox(

                width:
                    double.infinity,

                height:
                    50,


                child:
                    ElevatedButton.icon(

                  onPressed:
                      () async {

                    final success =
                        await CameraService
                            .openCamera();


                    if (!context
                        .mounted) {
                      return;
                    }


                    if (!success) {

                      ScaffoldMessenger
                              .of(context)
                          .showSnackBar(

                        const SnackBar(

                          content:
                              Text(

                            'تعذر فتح الكاميرا',

                            style:
                                TextStyle(
                              fontFamily:
                                  'Cairo',
                            ),

                          ),

                          backgroundColor:
                              Colors.red,

                        ),

                      );

                    }

                  },


                  icon:
                      const Icon(

                    Icons.camera_alt_rounded,

                  ),


                  label:
                      const Text(

                    'فتح الكاميرا',

                    style:
                        TextStyle(

                      fontFamily:
                          'Cairo',

                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),


                  style:
                      ElevatedButton
                          .styleFrom(

                    backgroundColor:
                        AppColors.primary,

                    foregroundColor:
                        Colors.white,

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),

                    ),

                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}