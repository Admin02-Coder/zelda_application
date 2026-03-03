import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';

/// Security Settings Screen
class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: Text(
                        'Security',
                        style: AppTypography.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildSectionTitle('Authentication'),
                    GlassCard(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(Icons.lock, color: AppColors.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'PIN Lock',
                              style: AppTypography.titleMedium,
                            ),
                          ),
                          Switch(
                            value: true,
                            onChanged: (value) {},
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    GlassCard(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(Icons.fingerprint, color: AppColors.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Biometric Authentication',
                              style: AppTypography.titleMedium,
                            ),
                          ),
                          Switch(
                            value: false,
                            onChanged: (value) {},
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Privacy'),
                    GlassCard(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(Icons.location_off, color: AppColors.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Location Sharing',
                              style: AppTypography.titleMedium,
                            ),
                          ),
                          Switch(
                            value: true,
                            onChanged: (value) {},
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    GlassCard(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(Icons.visibility_off, color: AppColors.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Incognito Mode',
                              style: AppTypography.titleMedium,
                            ),
                          ),
                          Switch(
                            value: false,
                            onChanged: (value) {},
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Data'),
                    GlassCard(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(Icons.delete_forever, color: AppColors.error),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Delete All Data',
                              style: AppTypography.titleMedium.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppTypography.labelLarge.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
