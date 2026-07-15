import 'package:flutter/material.dart';
import 'package:fix_it/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:fix_it/providers/order_provider.dart';
import 'package:fix_it/order_details_page.dart';
class OrderSituations extends StatefulWidget {
  const OrderSituations({super.key});

  @override
  State<OrderSituations> createState() => _OrderSituationsState();
}

class _OrderSituationsState extends State<OrderSituations> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() { //*to wait millisecond to draw the page *//
      context.read<OrderProvider>().getMyOrders(); //*to get the order when the user open the page *//
    });
  }

  Widget _ordersList(List<dynamic> orders, String emptyMessage) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
      );
    }

    return RefreshIndicator( //*to refresh the page and get the orders 
      onRefresh: context.read<OrderProvider>().getMyOrders,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = orders[index];

          return InkWell(
  borderRadius: BorderRadius.circular(16),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(
          orderId: order.id,
        ),
      ),
    );
  },
  child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.specializationName,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  order.description,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  order.addressText ?? 'لا يوجد عنوان', //*if the address empty he show that 
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'رقم الطلب: ${order.id}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ));
  
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor:
            AppColors.background, // الحفاظ على الخلفية الداكنة للتطبيق
        // 2. إنشاء الـ TabBar في الجزء العلوي
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
            50,
          ), // تحديد ارتفاع مناسب للـ TabBar
          child: Container(
            color: AppColors.background,
            child: TabBar(
              // تخصيص التصميم ليتناسب مع الهوية البصرية الفخمة لـ FIXIT
              indicatorColor:
                  AppColors.primary, // لون الخط السفلي المضيء للتبويب النشط
              indicatorWeight: 3, // سمك الخط السفلي
              labelColor: AppColors.primary, // لون نص التبويب النشط
              unselectedLabelColor:
                  AppColors.textSecondary, //! لون نص التبويب غير النشط
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
        body: Consumer<OrderProvider>(
          builder: (context, orderProvider, child) {
            if (orderProvider.isLoadingMyOrders) {
              return const Center(child: CircularProgressIndicator());
            }

            if (orderProvider.myOrdersError != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      orderProvider.myOrdersError!,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.red,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<OrderProvider>().getMyOrders();
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            final activeOrders = orderProvider.myOrders
                .where((order) => order.status != 4 && order.status != 5)
                .toList();

            final completedOrders = orderProvider.myOrders
                .where((order) => order.status == 4)
                .toList();

            return TabBarView(
              children: [
                _ordersList(activeOrders, 'لا توجد طلبات جارية حالياً 🛠️'),//*this massege if the orders empty 
                _ordersList(completedOrders, 'سجل الطلبات المكتملة فارغ 📁'),
              ],
            );
          },
        ),
      ),
    );
  }
}
