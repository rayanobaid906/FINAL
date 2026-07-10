import 'package:flutter/material.dart';
import 'package:fix_it/app_colors.dart';
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationPage> {
  // حالة التحميل (Loading State) لمحاكاة جلب البيانات من السيرفر
  bool _isLoading = true;

  // قائمة الإشعارات التجريبية (Mock Data) الخاصة بسياق العميل حسب الـ MVP (صفحة 16)
  // إذا كانت القائمة فارغة [] ستعرض الشاشة تلقائياً حالة "لا توجد إشعارات"
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotificationsMock();
  }

  // دالة لمحاكاة جلب البيانات اللحظية من السيرفر بتأخير ثانيتين
  Future<void> _fetchNotificationsMock() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _notifications = [
          {
            "id": "1",
            "title": "عرض سعر جديد",
            "message":
                "قام الفني أحمد بتقديم عرض سعر بقيمة 450 ليرة على طلب صيانة المكيف الخاص بك.",
            "time": "منذ دقيقتين",
            "type": "offer", // لتحديد الأيقونة واللون ديناميكياً
            "isRead": false, // حالة القراءة
          },
          {
            "id": "2",
            "title": "تم قبول العرض",
            "message":
                "تأكيد: تم اعتماد الفني خالد لبدء صيانة الغسالة، وهو في طريقه إليك الآن.",
            "time": "منذ ساعة",
            "type": "progress",
            "isRead": false,
          },
          {
            "id": "3",
            "title": "اكتمل الطلب بنجاح",
            "message":
                "لقد قام الفني بإنهاء العمل ومسح الـ QR بنجاح. الرجاء تقييم مقدم الخدمة الآن.",
            "time": "أمس",
            "type": "completed",
            "isRead": true,
          },
        ];
        _isLoading = false; // إنهاء حالة التحميل
      });
    }
  }

  // دالة مساعدة لتحديد أيقونة ولون الإشعار بناءً على نوعه (Type) ليعطي مظهراً فخماً
  IconData _getIcon(String type) {
    switch (type) {
      case 'offer':
        return Icons.local_offer_rounded;
      case 'progress':
        return Icons.build_circle_rounded;
      case 'completed':
        return Icons.check_circle_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'offer':
        return Colors.blue;
      case 'progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      default:
        return AppColors.primary;
    }
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
          "الإشعارات والتنبيهات",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_isLoading && _notifications.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.done_all_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              tooltip: "تحديد الكل كمقروء",
              onPressed: () {
                setState(() {
                  for (var n in _notifications) {
                    n['isRead'] = true;
                  }
                });
              },
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  // بناء محتوى الشاشة بناءً على الحالات الرسومية الثلاث
  Widget _buildBody() {
    // 1. حالة التحميل (Loading State)
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    // 2. حالة القائمة الفارغة (Empty State)
    if (_notifications.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_off_rounded,
                  size: 64,
                  color: AppColors.textSecondary.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "صندوق الإشعارات فارغ",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "لا توجد أي تنبيهات أو تحديثات بخصوص طلباتك حالياً. سيتم إشعارك فور حدوث أي جديد.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 3. حالة قائمة الإشعارات (List State)
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        setState(() => _isLoading = true);
        await _fetchNotificationsMock();
      },
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final item = _notifications[index];
          final bool isRead = item['isRead'] ?? false;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              // إذا كان الإشعار غير مقروء، نضع خلفية خفيفة جداً لتمييزه
              color: isRead
                  ? AppColors.surface
                  : AppColors.primary.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isRead
                    ? AppColors.primary.withOpacity(0.03)
                    : AppColors.primary.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getIconColor(item['type']).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIcon(item['type']),
                  color: _getIconColor(item['type']),
                  size: 24,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['title'],
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: isRead ? FontWeight.bold : FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    item['time'],
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  item['message'],
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: isRead
                        ? AppColors.textSecondary
                        : AppColors.textPrimary.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ),
              onTap: () {
                // عند الضغط على الإشعار يتم تحويل حالته إلى مقروء تلقائياً
                setState(() {
                  _notifications[index]['isRead'] = true;
                });
              },
            ),
          );
        },
      ),
    );
  }
}
