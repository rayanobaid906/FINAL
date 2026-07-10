import 'package:flutter/material.dart';
import 'package:fix_it/app_colors.dart';
class OrderSituations extends StatefulWidget {
  const OrderSituations({super.key});

  @override
  State<OrderSituations> createState() => _OrderSituationsState();
}

class _OrderSituationsState extends State<OrderSituations> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background, // الحفاظ على الخلفية الداكنة للتطبيق
        
        // 2. إنشاء الـ TabBar في الجزء العلوي
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50), // تحديد ارتفاع مناسب للـ TabBar
          child: Container(
            color: AppColors.background,
            child: TabBar(
              // تخصيص التصميم ليتناسب مع الهوية البصرية الفخمة لـ FIXIT
              indicatorColor: AppColors.primary, // لون الخط السفلي المضيء للتبويب النشط
              indicatorWeight: 3, // سمك الخط السفلي
              labelColor: AppColors.primary, // لون نص التبويب النشط
              unselectedLabelColor: AppColors.textSecondary, // لون نص التبويب غير النشط
              labelStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: "طلبات جارية"),
                Tab(text: "طلبات منتهية"),
              ],
            ),
          ),
        ),

        // 3. محتوى كل تبويب (الـ Pages الداخلية التي تتبدل عند الضغط أو السحب)
        body: const TabBarView(
          children: [
            // محتوى التبويب الأول: طلبات جارية
            Center(
              child: Text(
                "لا توجد طلبات جارية حالياً 🛠️",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ),
            
            // محتوى التبويب الثاني: طلبات منتهية
            Center(
              child: Text(
                "سجل الطلبات المكتملة فارغ 📁",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  
