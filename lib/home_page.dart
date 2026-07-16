import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fix_it/app_colors.dart';
import 'package:fix_it/create_order.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;
  

  final List<Map<String, dynamic>> _benefits = [
    {
      "title": "استقبل عروض الأسعار",
      "desc": "أنشئ طلب صيانة ودع الفنيين المتخصصين يقدمون عروضهم",
      "icon": Icons.local_offer_rounded,
      "bg": const Color(0xFF1E293B),
    },
    {
      "title": "خصوصية وأمان تام",
      "desc": "رقم هاتفك محمي تماماً ولا يظهر للطرف الآخر إلا بعد قبولك",
      "icon": Icons.shield_rounded,
      "bg": const Color(0xFF1E2640),
    },
    {
      "title": "إغلاق ذكي بالـ QR",
      "desc": "تأكيد إنهاء العمل والدفع يتم بأمان تام بمجرد مسح رمز الـ QR",
      "icon": Icons.qr_code_scanner_rounded,
      "bg": const Color(0xFF2E1B28),
    },
  ];

  final List<Map<String, dynamic>> _services = [
    {"name": "كهرباء", "icon": Icons.bolt_rounded, "color": Colors.amber},
    {"name": "سباكة", "icon": Icons.water_drop_rounded, "color": Colors.blue},
    {
      "name": "أجهزة منزلية",
      "icon": Icons.kitchen_rounded,
      "color": Colors.orange,
    },
    {
      "name": "تكييف وتبريد",
      "icon": Icons.ac_unit_rounded,
      "color": Colors.cyan,
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _benefits.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      
      physics: const BouncingScrollPhysics(),
       
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. الـ Header الترحيبي (تم تصغير الـ Padding والخطوط لرفع المحتوى)
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              left: 20.0,
              right: 20.0,
              bottom: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "مرحباً بك في FIXIT 👋",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "إصلاحاتك المنزلية أصبحت أسهل",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // 2. الكاروسيل الأوتوماتيكي (تم تصغير الارتفاع من 140 إلى 100 ليصبح نحيفاً جداً)
          SizedBox(
            height: 100,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _benefits.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final item = _benefits[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 2,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: item['bg'],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item['title'],
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['desc'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                color: AppColors.textPrimary,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item['icon'],
                          size: 24,
                          color: AppColors.primary,
                        ), // تصغير الأيقونة لـ 24
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // نقاط المؤشر أسفل الكاروسيل (تم تصغير الـ Padding العمودي)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _benefits.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                width: _currentPage == index ? 14 : 5,
                height: 5,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColors.primary
                      : AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
          ),

          // عنوان قسم التخصصات (أصبح الآن مرتفعاً للأعلى تماماً)
          const Padding(
            padding: EdgeInsets.only(
              top: 10.0,
              left: 20.0,
              right: 20.0,
              bottom: 8.0,
            ),
            child: Text(
              "بعض التخصصات المتاحة",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // 3. شبكة التخصصات الأربعة (تعمل كأزرار مباشرة للطلب)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _services.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio:
                    1.2, // زيادة النسبة لتصغير الكروت عمودياً وجعلها منبسطة
              ),
              itemBuilder: (context, index) {
                final service = _services[index];
                return InkWell(
                  // onTap: () {
                  //   print("تم الضغط لإنشاء طلب تخصص: ${service['name']}");
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => const CreateOrder(),
                  //     ),
                  //   );
                  // },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: service['color'].withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            service['icon'],
                            size: 24,
                            color: service['color'],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          service['name'],
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // عنوان قسم طلب صيانة سريع
          const Padding(
            padding: EdgeInsets.only(
              top: 18.0,
              left: 20.0,
              right: 20.0,
              bottom: 8.0,
            ),
            child: Text(
              "طلب صيانة سريع",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // 4. كارت وزر "طلب صيانة فوري عام" المضغوط والجميل في الأسفل
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.75),// تدرج لوني بسيط لإضافة عمق وجاذبية
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    print("تم الضغط على زر طلب صيانة فوري عام");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateOrder(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 14.0,
                    ), // تقليص الـ Padding الداخلي لتقفيل المساحة
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "هل تواجه عطلاً مفاجئاً؟",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "اضغط هنا لإنشاء طلبك الآن ودع الفنيين يقدمون عروضهم",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 11,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w800,
                                  height: 1.9,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_task_rounded,
                            size: 22,
                            color: AppColors.background,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // مسافة أمان سفلي صغيرة خفيفة
        ],
      ),
    );
  }
}
