import 'package:fix_it/about_us.dart';
import 'package:fix_it/provider_main_page.dart';
import 'package:fix_it/providers/notification_provider.dart';
import 'package:fix_it/providers/provider_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:fix_it/app_colors.dart';
import 'package:fix_it/home_page.dart';
import 'package:fix_it/to_be_provider.dart';
import 'package:fix_it/order_situation.dart';
import 'package:provider/provider.dart';
import 'package:fix_it/notification_page.dart';
import 'package:fix_it/providers/auth_provider.dart';
import 'package:fix_it/login_page.dart';
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
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<ProviderProfileProvider>().checkProviderProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
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
                // 2. فتح صفحة الإشعارات
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                );
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
                color: AppColors.primary.withValues(alpha: 0.4),
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

              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 5.0,
              //     vertical: 4.0,
              //   ),
              // child: Card(
              //   color: const Color(0xFF222539),
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: ListTile(
              //     leading: const Icon(
              //       Icons.settings_rounded,
              //       color: Colors.amberAccent,
              //     ), // أيقونة بلون دافئ مميز
              //     title: const Text(
              //       "الإعدادات",
              //       style: TextStyle(
              //         fontFamily: 'Cairo',
              //         color: AppColors.textPrimary,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     subtitle: const Text(
              //       "العناوين، التنبيهات، والأمان",
              //       style: TextStyle(
              //         fontFamily: 'Cairo',
              //         color: AppColors.textSecondary,
              //         fontSize: 11,
              //       ),
              //     ),
              //     trailing: const Icon(
              //       Icons.arrow_back_ios_new_rounded,
              //       color: AppColors.textSecondary,
              //       size: 14,
              //     ),
              //     onTap: () => Navigator.pop(context),
              //   ),
              // ),
              //),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Consumer<ProviderProfileProvider>(
                  builder: (context, providerProfile, child) {
                    final hasProfile = providerProfile.hasProviderProfile;

                    return Card(
                      color: const Color(0xFF222539),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),

                        side: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.3),

                          width: 1,
                        ),
                      ),

                      child: ListTile(
                        leading: Icon(
                          hasProfile
                              ? Icons.engineering_rounded
                              : Icons.build_circle_rounded,

                          color: AppColors.primary,
                        ),

                        title: Text(
                          hasProfile
                              ? "حساب مقدم الخدمة"
                              : "كن مزود خدمة (فني)",

                          style: const TextStyle(
                            fontFamily: 'Cairo',

                            color: AppColors.primary,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Text(
                          hasProfile
                              ? "إدارة الطلبات والعروض الخاصة بك"
                              : "انضم إلينا واستقبل طلبات الصيانة",

                          style: const TextStyle(
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

                        onTap: () async {
                          Navigator.pop(context);

                          final profileProvider =
                              context.read<ProviderProfileProvider>();
                          final profileExists =
                              await profileProvider.checkProviderProfile();

                          if (!context.mounted) return;

                          if (profileExists) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProviderMainPage(),
                              ),
                            );
                          } else if (profileProvider.errorMessage == null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ToBeProvider(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(profileProvider.errorMessage!),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 450),
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
                      Icons.info_outline_rounded,
                      color: AppColors.primary,
                    ),
                    title: const Text(
                      "لمحة عن التطبيق",
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
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutPage()),
                      );
                    },
                  ),
                ),
              ),

              // --------------------------------------------------------
              // سبيس أو مساحة فارغة سحرية (Spacer) تدفع أي كود تحتها إلى قاع الشاشة فوراً
              const Spacer(),
              // --------------------------------------------------------
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Card(
                      color: const Color(0xFF2A1B24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.redAccent.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        leading: authProvider.isLoggingOut
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.redAccent,
                                ),
                              )
                            : const Icon(
                                Icons.logout_rounded,
                                color: Colors.redAccent,
                              ),

                        title: Text(
                          authProvider.isLoggingOut
                              ? 'جاري تسجيل الخروج...'
                              : 'تسجيل الخروج',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),

                        onTap: authProvider.isLoggingOut
                            ? null
                            : () async {
                                Navigator.pop(context);

                                final success = await authProvider.logout();

                                if (!context.mounted) return;

                                if (success) {
                                  context
                                      .read<ProviderProfileProvider>()
                                      .reset();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginPage(),
                                    ),
                                    (route) => false,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        authProvider.logoutError ??
                                            'فشل تسجيل الخروج',
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                      ),
                    ),
                  );
                },
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
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
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
