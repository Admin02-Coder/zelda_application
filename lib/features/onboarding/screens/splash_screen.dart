import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/services/permission_service.dart';

/// Splash Screen - Initial loading screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for animation and initial load
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    // Get permission service
    final permissionService = context.read<PermissionService>();
    
    // Check if onboarding is complete
    final isOnboardingComplete = await permissionService.isOnboardingComplete();
    
    // Request permissions on first launch if not already requested
    if (!isOnboardingComplete) {
      // First launch - go to onboarding
      if (mounted) {
        context.go('/onboarding');
      }
    } else {
      // Check and request permissions
      final hasLocation = await permissionService.isLocationGranted();
      final hasMic = await permissionService.isMicrophoneGranted();
      
      // Show rationale dialogs before requesting permissions
      if (!hasLocation) {
        final locationAllowed = await _showLocationRationaleDialog();
        if (!mounted) return;
        if (locationAllowed) {
          await permissionService.requestLocationPermission();
        }
      }
      
      if (!hasMic) {
        final micAllowed = await _showMicrophoneRationaleDialog();
        if (!mounted) return;
        if (micAllowed) {
          await permissionService.requestMicrophonePermission();
        }
      }
      
      // Navigate based on auth state
      if (mounted) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // User is authenticated, go to home
          context.go('/');
        } else {
          // Not authenticated, go to login
          context.go('/login');
        }
      }
    }
  }

  Future<bool> _showLocationRationaleDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.location_on, color: AppColors.primary, size: 48),
        title: Text(
          'Location Permission',
          style: AppTypography.headlineMedium,
          textAlign: TextAlign.center,
        ),
        content: Text(
          'We need your location to help you quickly report emergencies and connect you with nearby emergency services.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Skip', style: AppTypography.buttonMedium.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Allow', style: AppTypography.buttonMedium),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<bool> _showMicrophoneRationaleDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.mic, color: AppColors.primary, size: 48),
        title: Text(
          'Microphone Permission',
          style: AppTypography.headlineMedium,
          textAlign: TextAlign.center,
        ),
        content: Text(
          'We need microphone access so you can quickly record voice messages during emergency situations.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Skip', style: AppTypography.buttonMedium.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Allow', style: AppTypography.buttonMedium),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.emergency,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // App Name
                      Text(
                        'ZELDA',
                        style: AppTypography.emergencyText.copyWith(
                          letterSpacing: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Emergency Response System',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Loading indicator
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
