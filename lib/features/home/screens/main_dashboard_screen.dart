import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';

/// Main Dashboard Screen - Emergency SOS button and main controls
class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen>
    with SingleTickerProviderStateMixin {
  bool _trackMeEnabled = false;
  bool _voiceAlertEnabled = false;
  bool _isEmergencyLoading = false;
  bool _isVoiceLoading = false;
  bool _isShareLoading = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleVoiceAlert() async {
    setState(() => _isVoiceLoading = true);
    
    // Simulate processing
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;
    
    setState(() {
      _voiceAlertEnabled = !_voiceAlertEnabled;
      _isVoiceLoading = false;
    });
    
    _showSnackBar(
      _voiceAlertEnabled 
        ? 'Voice Alert enabled' 
        : 'Voice Alert disabled'
    );
  }

  Future<void> _handleShareLocation() async {
    setState(() => _isShareLoading = true);
    
    // Simulate processing
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;
    
    setState(() => _isShareLoading = false);
    
    _showSnackBar('Location shared successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ZELDA',
                          style: AppTypography.headlineLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'Emergency Response',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Track Me Toggle
                        GlassCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: _trackMeEnabled
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Track Me',
                                style: AppTypography.labelMedium,
                              ),
                              const SizedBox(width: 8),
                              Switch(
                                value: _trackMeEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    _trackMeEnabled = value;
                                  });
                                  _showSnackBar(
                                    value 
                                      ? 'Location tracking enabled' 
                                      : 'Location tracking disabled'
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // SOS Button
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Emergency Status
                      Text(
                        'Tap for Emergency',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // SOS Button
                      _isEmergencyLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            )
                          : GestureDetector(
                              onTap: () async {
                                setState(() => _isEmergencyLoading = true);
                                await Future.delayed(const Duration(milliseconds: 300));
                                if (mounted) {
                                  context.go('/active-emergency');
                                }
                              },
                              child: AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        gradient: AppColors.emergencyGradient,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.secondary
                                                .withValues(alpha: 0.4),
                                            blurRadius: 30,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.emergency,
                                              size: 60,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'SOS',
                                              style:
                                                  AppTypography.emergencyText.copyWith(
                                                color: Colors.white,
                                                fontSize: 36,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                      const SizedBox(height: 32),
                      // Quick Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildQuickAction(
                            icon: _isVoiceLoading ? Icons.hourglass_empty : Icons.mic,
                            label: _isVoiceLoading ? 'Loading...' : 'Voice\nAlert',
                            isLoading: _isVoiceLoading,
                            onTap: _handleVoiceAlert,
                          ),
                          _buildQuickAction(
                            icon: Icons.history,
                            label: 'Emergency\nHistory',
                            onTap: () => context.go('/emergency-history'),
                          ),
                          _buildQuickAction(
                            icon: _isShareLoading ? Icons.hourglass_empty : Icons.share,
                            label: _isShareLoading ? 'Loading...' : 'Share\nLocation',
                            isLoading: _isShareLoading,
                            onTap: _handleShareLocation,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: GlassCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isLoading
                ? const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTypography.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
