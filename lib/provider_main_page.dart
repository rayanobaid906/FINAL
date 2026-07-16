import 'package:flutter/material.dart';

import 'package:fix_it/app_colors.dart';
import 'package:fix_it/provider_assigned_orders_page.dart';
import 'package:fix_it/provider_available_orders_page.dart';
import 'package:fix_it/provider_profile_page.dart';
import 'package:fix_it/my_offers_page.dart';

import 'package:fix_it/subscription_plans_page.dart';
import 'package:fix_it/my_provider_subscriptions_page.dart';


class ProviderMainPage extends StatefulWidget {
  const ProviderMainPage({
    super.key,
  });

  @override
  State<ProviderMainPage> createState() =>
      _ProviderMainPageState();
}


class _ProviderMainPageState
    extends State<ProviderMainPage> {

  int _selectedIndex = 0;


  final List<Widget> _pages = const [

    ProviderAvailableOrdersPage(),

    ProviderAssignedOrdersPage(),

    MyOffersPage(),

    ProviderProfilePage(),

  ];


  void _showSubscriptionOptions() {

    showModalBottomSheet(

      context: context,

      backgroundColor:
          AppColors.surface,

      shape: const RoundedRectangleBorder(

        borderRadius:
            BorderRadius.vertical(

          top:
              Radius.circular(24),

        ),

      ),


      builder: (context) {

        return SafeArea(

          child: Padding(

            padding:
                const EdgeInsets.all(16),


            child: Column(

              mainAxisSize:
                  MainAxisSize.min,


              children: [


                const Text(

                  'إدارة الاشتراك',

                  style:
                      TextStyle(

                    fontFamily:
                        'Cairo',

                    fontSize:
                        18,

                    fontWeight:
                        FontWeight.bold,

                    color:
                        AppColors.textPrimary,

                  ),

                ),


                const SizedBox(
                  height: 16,
                ),



                ListTile(

                  leading:
                      const Icon(

                    Icons
                        .workspace_premium_rounded,

                    color:
                        AppColors.primary,

                  ),


                  title:
                      const Text(

                    'خطط الاشتراك',

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


                  subtitle:
                      const Text(

                    'عرض الخطط المتاحة وتقديم طلب اشتراك',

                    style:
                        TextStyle(

                      fontFamily:
                          'Cairo',

                      color:
                          AppColors.textSecondary,

                      fontSize:
                          12,

                    ),

                  ),


                  trailing:
                      const Icon(

                    Icons
                        .arrow_back_ios_new_rounded,

                    color:
                        AppColors.textSecondary,

                    size:
                        14,

                  ),


                  onTap: () {

                    Navigator.pop(
                      context,
                    );


                    Navigator.push(

                      this.context,

                      MaterialPageRoute(

                        builder: (_) =>
                            const SubscriptionPlansPage(),

                      ),

                    );

                  },

                ),



                const Divider(),



                ListTile(

                  leading:
                      const Icon(

                    Icons
                        .card_membership_rounded,

                    color:
                        AppColors.primary,

                  ),


                  title:
                      const Text(

                    'اشتراكي الحالي',

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


                  subtitle:
                      const Text(

                    'عرض تفاصيل وحالة الاشتراك الحالي',

                    style:
                        TextStyle(

                      fontFamily:
                          'Cairo',

                      color:
                          AppColors.textSecondary,

                      fontSize:
                          12,

                    ),

                  ),


                  trailing:
                      const Icon(

                    Icons
                        .arrow_back_ios_new_rounded,

                    color:
                        AppColors.textSecondary,

                    size:
                        14,

                  ),


                  onTap: () {

                    Navigator.pop(
                      context,
                    );


                    Navigator.push(

                      this.context,

                      MaterialPageRoute(

                        builder: (_) =>
                            const MyProviderSubscriptionsPage(),

                      ),

                    );

                  },

                ),

              ],

            ),

          ),

        );

      },

    );

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppColors.background,


      appBar: AppBar(

        iconTheme:
            const IconThemeData(

          color:
              Colors.white,

        ),


        backgroundColor:
            AppColors.background,


        elevation:
            0,


        centerTitle:
            true,


        title:
            const Text(

          'لوحة مقدم الخدمة',

          style:
              TextStyle(

            fontFamily:
                'Cairo',

            fontWeight:
                FontWeight.bold,

            color:
                AppColors.textPrimary,

          ),

        ),


        actions: [

          IconButton(

            tooltip:
                'الاشتراكات',


            onPressed:
                _showSubscriptionOptions,


            icon:
                const Icon(

              Icons
                  .workspace_premium_rounded,

              color:
                  AppColors.primary,

            ),

          ),


          const SizedBox(
            width: 8,
          ),

        ],

      ),


      body:
          _pages[_selectedIndex],


      bottomNavigationBar:
          BottomNavigationBar(

        currentIndex:
            _selectedIndex,


        type:
            BottomNavigationBarType.fixed,


        backgroundColor:
            AppColors.surface,


        selectedItemColor:
            AppColors.primary,


        unselectedItemColor:
            AppColors.textSecondary,


        onTap:
            (index) {

          setState(() {

            _selectedIndex =
                index;

          });

        },


        items:
            const [


          BottomNavigationBarItem(

            icon:
                Icon(
              Icons.search_rounded,
            ),

            label:
                'المتاحة',

          ),


          BottomNavigationBarItem(

            icon:
                Icon(
              Icons.handyman_rounded,
            ),

            label:
                'طلباتي',

          ),


          BottomNavigationBarItem(

            icon:
                Icon(
              Icons.local_offer_rounded,
            ),

            label:
                'عروضي',

          ),


          BottomNavigationBarItem(

            icon:
                Icon(
              Icons.person_rounded,
            ),

            label:
                'ملفي',

          ),

        ],

      ),

    );

  }

}