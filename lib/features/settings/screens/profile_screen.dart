import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../core/services/auth_service.dart';

/// Profile Screen - User profile management
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser;

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
                        'Profile',
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
                    // User Info Card
                    GlassCard(
                      child: Column(
                        children: [
                          // Avatar
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Email
                          Text(
                            user?.email ?? 'Not logged in',
                            style: AppTypography.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          // Verification status
                          Text(
                            user?.emailVerified == true 
                                ? 'Verified' 
                                : 'Email not verified',
                            style: AppTypography.bodySmall.copyWith(
                              color: user?.emailVerified == true 
                                  ? AppColors.success 
                                  : AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Account Section
                    _buildSectionTitle('Account'),
                    GlassCard(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline, color: AppColors.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Edit Profile',
                              style: AppTypography.titleMedium,
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    GlassCard(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(Icons.lock_outline, color: AppColors.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Change Password',
                              style: AppTypography.titleMedium,
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    GlassCard(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(Icons.notifications_outlined, color: AppColors.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Notification Preferences',
                              style: AppTypography.titleMedium,
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
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
