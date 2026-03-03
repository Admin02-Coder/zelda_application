import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/home/screens/main_dashboard_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/emergency/screens/active_emergency_screen.dart';
import '../../features/emergency/screens/emergency_history_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/settings/screens/trigger_config_screen.dart';
import '../../features/settings/screens/trusted_contacts_screen.dart';
import '../../features/settings/screens/notification_settings_screen.dart';
import '../../features/settings/screens/security_settings_screen.dart';
import '../../features/settings/screens/profile_screen.dart';
import '../../features/police/screens/police_register_screen.dart';
import '../../features/police/screens/emergency_details_screen.dart';
import '../../features/police/screens/police_dashboard_screen.dart';
import '../../features/police/screens/live_map_screen.dart';
import '../../features/police/screens/police_login_screen.dart';

/// ZELDA App Router Configuration using GoRouter
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Skip redirect for splash, onboarding, and police routes
      final path = state.uri.path;
      if (path == '/splash' || 
          path == '/onboarding' || 
          path.startsWith('/police')) {
        return null;
      }
      
      // Check current auth state
      final user = FirebaseAuth.instance.currentUser;
      
      // If not authenticated and trying to access protected route, go to login
      if (user == null && 
          !path.startsWith('/login') && 
          !path.startsWith('/register') && 
          !path.startsWith('/otp')) {
        return '/login';
      }
      
      // If authenticated and trying to access auth routes, go to home
      if (user != null && 
          (path.startsWith('/login') || 
           path.startsWith('/register') || 
           path.startsWith('/otp'))) {
        return '/';
      }
      
      return null;
    },
    routes: [
      // Splash & Onboarding
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) => const OtpScreen(),
      ),
      
      // Main App Routes
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'dashboard',
            name: 'dashboard',
            builder: (context, state) => const MainDashboardScreen(),
          ),
          GoRoute(
            path: 'active-emergency',
            name: 'active-emergency',
            builder: (context, state) => const ActiveEmergencyScreen(),
          ),
          GoRoute(
            path: 'emergency-history',
            name: 'emergency-history',
            builder: (context, state) => const EmergencyHistoryScreen(),
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
            routes: [
              GoRoute(
                path: 'profile',
                name: 'settings-profile',
                builder: (context, state) => const ProfileScreen(),
              ),
              GoRoute(
                path: 'trigger-config',
                name: 'settings-trigger-config',
                builder: (context, state) => const TriggerConfigScreen(),
              ),
              GoRoute(
                path: 'trusted-contacts',
                name: 'settings-trusted-contacts',
                builder: (context, state) => const TrustedContactsScreen(),
              ),
              GoRoute(
                path: 'notification-settings',
                name: 'settings-notification',
                builder: (context, state) => const NotificationSettingsScreen(),
              ),
              GoRoute(
                path: 'security-settings',
                name: 'settings-security',
                builder: (context, state) => const SecuritySettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      
      // Police Routes
      GoRoute(
        path: '/police',
        name: 'police',
        builder: (context, state) => const PoliceLoginScreen(),
        routes: [
          GoRoute(
            path: 'register',
            name: 'police-register',
            builder: (context, state) => const PoliceRegisterScreen(),
          ),
          GoRoute(
            path: 'dashboard',
            name: 'police-dashboard',
            builder: (context, state) => const PoliceDashboardScreen(),
          ),
          GoRoute(
            path: 'emergency',
            name: 'emergency-details',
            builder: (context, state) => const EmergencyDetailsScreen(),
          ),
          GoRoute(
            path: 'live-map',
            name: 'police-live-map',
            builder: (context, state) => const LiveMapScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );
}
