import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
import '../../features/police/screens/police_register_screen.dart';
import '../../features/police/screens/emergency_details_screen.dart';
import '../../features/police/screens/police_dashboard_screen.dart';
import '../../features/police/screens/live_map_screen.dart';

/// ZELDA App Router Configuration using GoRouter
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
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
          ),
        ],
      ),
      
      // Police Routes
      GoRoute(
        path: '/police',
        name: 'police',
        builder: (context, state) => const Placeholder(),
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
