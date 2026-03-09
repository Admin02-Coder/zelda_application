import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';

/// Settings Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                        'Settings',
                        style: AppTypography.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // Settings List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // Account Section
                    _buildSectionTitle('Account'),
                    GlassCard(
                      onTap: () => context.go('/settings/profile'),
                      child: Row(
                        children: [
                          const Icon(Icons.person, color: AppColors.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Profile',
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
                    const SizedBox(height: 24),
                    // Emergency Settings
                    _buildSectionTitle('Emergency'),
                    GlassCard(
                      onTap: () => context.go('/settings/trigger-config'),
                      child: Row(
                        children: [
                          const Icon(Icons.tune, color: AppColors.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Trigger Configuration',
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
                    GlassCard(
                      onTap: () => context.go('/settings/trusted-contacts'),
                      child: Row(
                        children: [
                          const Icon(Icons.contacts, color: AppColors.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Trusted Contacts',
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
                    const SizedBox(height: 24),
                    // App Settings
                    _buildSectionTitle('App'),
                    GlassCard(
                      onTap: () => context.go('/settings/notification-settings'),
                      child: Row(
                        children: [
                          const Icon(Icons.notifications, color: AppColors.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Notifications',
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
                    GlassCard(
                      onTap: () => context.go('/settings/security-settings'),
                      child: Row(
                        children: [
                          const Icon(Icons.security, color: AppColors.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Security',
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
                    const SizedBox(height: 24),
                    // About
                    _buildSectionTitle('About'),
                    GlassCard(
                      onTap: () => _showAboutDialog(context),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppColors.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'About ZELDA',
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
                    const SizedBox(height: 16),
                    GlassCard(
                      onTap: () => _showLogoutDialog(context),
                      child: Row(
                        children: [
                          const Icon(Icons.logout, color: AppColors.error),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Log Out',
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

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('About ZELDA', style: TextStyle(color: AppColors.textPrimary)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0', style: TextStyle(color: AppColors.textSecondary)),
            SizedBox(height: 8),
            Text(
              'ZELDA Emergency Location System\nYour safety companion for emergency situations.',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final authService = context.read<AuthService>();
              await authService.signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: const Text('Log Out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
