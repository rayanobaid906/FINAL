import 'package:flutter/material.dart';
import 'package:fix_it/app_colors.dart';
import 'package:fix_it/home_page.dart';
import 'package:fix_it/to_be_provider.dart';
import 'package:fix_it/order_situation.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isDarkMode = true;
  int _selectedIndex = 0;
  List<Widget> get _pages => [const HomePage(), const OrderSituations()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "FIXIT",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'cairo',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20.0,
            ), // إعطاء مسافة أمان مريحة للعين
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textPrimary,
                size: 26,
              ),
              onPressed: () {
                print("تم الضغط على زر الإشعارات المبعد عن الحافة");
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.surface,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              left: BorderSide(
                color: AppColors.primary.withOpacity(0.4),
                width: 1.5,
              ),
            ),
          ),
          child: Column(
            children: [
              // عنوان القائمة العلوي
              const Padding(
                padding: EdgeInsets.only(top: 60.0, bottom: 20.0),
                child: Text(
                  "القائمة الرئيسية",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              // 1. كارت الملف الشخصي (Profile Card)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 4.0,
                ),
                child: Card(
                  color: const Color(0xFF222539),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                    ),
                    title: const Text(
                      "الملف الشخصي",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textSecondary,
                      size: 14,
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 4.0,
                ),
                child: Card(
                  color: const Color(0xFF222539),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.settings_rounded,
                      color: Colors.amberAccent,
                    ), // أيقونة بلون دافئ مميز
                    title: const Text(
                      "الإعدادات",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      "العناوين، التنبيهات، والأمان",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textSecondary,
                      size: 14,
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Card(
                  color: const Color(
                    0xFF1E293B,
                  ), // درجة مختلفة قليلاً لتمييز خيار الورش والعمل
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ), // تحديد مضيء خفيف
                  ),
                  child: ListTile(
                    
                    
                    leading: const Icon(
                      Icons.build_circle_rounded,
                      color: AppColors.primary,
                    ),
                    title: const Text(
                      "كن مزود خدمة (فني)",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      "انضم إلينا واستقبل طلبات الصيانة",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.primary,
                      size: 14,
                    ),
                   onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ToBeProvider()),
                  ),
                ),
              ),
              ),
              // --------------------------------------------------------
              // سبيس أو مساحة فارغة سحرية (Spacer) تدفع أي كود تحتها إلى قاع الشاشة فوراً
              const Spacer(),
              // --------------------------------------------------------

              // --- كارت تسجيل الخروج في أسفل الـ Drawer تماماً ---
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20.0,
                ), // مسافة أمان من الأسفل
                child: Card(
                  color: const Color(
                    0xFF2A1B24,
                  ), // درجة داكنة مائلة للأحمر لتناسب مفهوم الـ Logout
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Colors.redAccent.withOpacity(0.2),
                      width: 1,
                    ), // إطار أحمر خفيف
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: Colors.redAccent,
                    ), // أيقونة باللون الأحمر
                    title: const Text(
                      "تسجيل الخروج",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.redAccent, // نص أحمر تحذيري أنيق
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      print("تم الضغط على تسجيل الخروج");
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],

      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          bottom: 3,
          top: 3,
        ), // مسافة أمان من الأعلى والأسفل
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 25,
        ), // مسافة أمان من الجوانب
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // margin: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: const Color.fromARGB(
                0,
                245,
                208,
                208,
              ), // إزالة تأثير النقر الافتراضي
              highlightColor:
                  Colors.transparent, // إزالة تأثير التحديد الافتراضي
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              backgroundColor: Colors.transparent,
              selectedItemColor: AppColors.primary,
              unselectedIconTheme: const IconThemeData(size: 24),
              selectedIconTheme: const IconThemeData(size: 28),
              unselectedItemColor: AppColors.textSecondary,
              selectedLabelStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.normal,
              ),
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: "الرئيسية",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt_rounded),
                  label: "طلباتي",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
