import 'package:flutter/material.dart';
import 'package:fix_it/app_colors.dart';
import 'package:fix_it/provider_assigned_orders_page.dart';
import 'package:fix_it/provider_available_orders_page.dart';
import 'package:fix_it/provider_profile_page.dart';
import 'package:fix_it/my_offers_page.dart';
class ProviderMainPage extends StatefulWidget {
  const ProviderMainPage({super.key});

  @override
  State<ProviderMainPage> createState() => _ProviderMainPageState();
}

class _ProviderMainPageState extends State<ProviderMainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
     ProviderAvailableOrdersPage(),
     ProviderAssignedOrdersPage(),
     MyOffersPage(),
     ProviderProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'لوحة مقدم الخدمة',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'المتاحة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman_rounded),
            label: 'طلباتي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_rounded),
            label: 'عروضي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'ملفي',
          ),
        ],
      ),
    );
  }
}