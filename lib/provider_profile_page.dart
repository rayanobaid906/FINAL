import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fix_it/app_colors.dart';
import 'package:fix_it/edit_provider_profile_page.dart';
import 'package:fix_it/providers/provider_profile_provider.dart';

class ProviderProfilePage extends StatelessWidget {
  const ProviderProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderProfileProvider>(
      builder: (context, provider, child) {
        final profile = provider.profile;

        if (profile == null) {
          return Center(
            child: ElevatedButton(
              onPressed: () async {
                await context
                    .read<ProviderProfileProvider>()
                    .checkProviderProfile();
              },
              child: const Text('تحميل الملف'),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fullName,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'التخصص: ${profile.specializationName}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'رقم الهاتف: ${profile.phoneNumber}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'النبذة: ${profile.bio?.isNotEmpty == true ? profile.bio : "لا توجد نبذة"}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const EditProviderProfilePage(),
                        ),
                      );

                      if (result == true && context.mounted) {
                        await context
                            .read<ProviderProfileProvider>()
                            .checkProviderProfile();
                      }
                    },
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text(
                      'تعديل الملف',
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}