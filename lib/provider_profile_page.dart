import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fix_it/app_colors.dart';
import 'package:fix_it/edit_provider_profile_page.dart';
import 'package:fix_it/providers/provider_profile_provider.dart';

class ProviderProfilePage extends StatefulWidget {
  const ProviderProfilePage({super.key});

  @override
  State<ProviderProfilePage> createState() =>
      _ProviderProfilePageState();
}

class _ProviderProfilePageState
    extends State<ProviderProfilePage> {
  bool _didLoadRatingSummary = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider =
          context.read<ProviderProfileProvider>();

      if (provider.profile == null) {
        await provider.checkProviderProfile();
      }

      if (!mounted) return;

      final profile = provider.profile;

      if (profile != null) {
        await provider.getRatingSummary(
          profile.id,
        );

        _didLoadRatingSummary = true;
      }
    });
  }

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

                if (!context.mounted) return;

                final loadedProfile = context
                    .read<ProviderProfileProvider>()
                    .profile;

                if (loadedProfile != null) {
                  await context
                      .read<ProviderProfileProvider>()
                      .getRatingSummary(
                        loadedProfile.id,
                      );
                }
              },
              child: const Text(
                'تحميل الملف',
                style: TextStyle(
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          );
        }

        // في حال كان profile موجودًا مسبقًا
        // ولم يتم تحميل التقييم بعد.
        if (!_didLoadRatingSummary &&
            !provider.isLoadingRatingSummary &&
            provider.ratingSummary == null) {
          _didLoadRatingSummary = true;

          Future.microtask(() {
            context
                .read<ProviderProfileProvider>()
                .getRatingSummary(
                  profile.id,
                );
          });
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
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
                  'النبذة: '
                  '${profile.bio?.isNotEmpty == true ? profile.bio : "لا توجد نبذة"}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 24),

                // ----------------------------
                // Rating Summary
                // ----------------------------

                if (provider.isLoadingRatingSummary)
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Center(
                      child:
                          CircularProgressIndicator(),
                    ),
                  )
                else if (provider.ratingSummaryError != null)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        Text(
                          provider.ratingSummaryError!,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.red,
                          ),
                        ),

                        const SizedBox(height: 8),

                        TextButton(
                          onPressed: () {
                            context
                                .read<
                                  ProviderProfileProvider
                                >()
                                .getRatingSummary(
                                  profile.id,
                                );
                          },
                          child: const Text(
                            'إعادة المحاولة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (provider.ratingSummary !=
                    null)
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceAround,
                      children: [
                        Column(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 28,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              provider
                                  .ratingSummary!
                                  .averageRating
                                  .toStringAsFixed(2),
                              style:
                                  const TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight:
                                    FontWeight.bold,
                                color: AppColors
                                    .textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'التقييم',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: AppColors
                                    .textSecondary,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          children: [
                            const Icon(
                              Icons.reviews_rounded,
                              color: AppColors.primary,
                              size: 28,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${provider.ratingSummary!.ratingsCount}',
                              style:
                                  const TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight:
                                    FontWeight.bold,
                                color: AppColors
                                    .textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'التقييمات',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: AppColors
                                    .textSecondary,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          children: [
                            const Icon(
                              Icons
                                  .check_circle_rounded,
                              color: Colors.green,
                              size: 28,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${provider.ratingSummary!.completedOrdersCount}',
                              style:
                                  const TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight:
                                    FontWeight.bold,
                                color: AppColors
                                    .textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'طلبات مكتملة',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                color: AppColors
                                    .textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result =
                          await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const EditProviderProfilePage(),
                        ),
                      );

                      if (result == true &&
                          context.mounted) {
                        final profileProvider =
                            context.read<
                              ProviderProfileProvider
                            >();

                        await profileProvider
                            .checkProviderProfile();

                        if (!context.mounted) return;

                        final updatedProfile =
                            profileProvider.profile;

                        if (updatedProfile != null) {
                          await profileProvider
                              .getRatingSummary(
                                updatedProfile.id,
                              );
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.edit_rounded,
                    ),
                    label: const Text(
                      'تعديل الملف',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                      ),
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