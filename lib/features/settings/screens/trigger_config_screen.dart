import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';

/// Trigger Configuration Screen
class TriggerConfigScreen extends StatelessWidget {
  const TriggerConfigScreen({super.key});

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
                        'Trigger Configuration',
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
                    GlassCard(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(Icons.volume_up, color: AppColors.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Volume Button Trigger',
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
                          const Icon(Icons.vibration, color: AppColors.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Shake to Trigger',
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
                          const Icon(Icons.timer, color: AppColors.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Auto Trigger Delay',
                              style: AppTypography.titleMedium,
                            ),
                          ),
                          const Text(
                            '5 sec',
                            style: TextStyle(color: AppColors.textSecondary),
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
}
