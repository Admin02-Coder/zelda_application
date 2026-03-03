import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase, FirebaseException;
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/services/auth_service.dart';
import 'core/services/permission_service.dart';
import 'core/services/location_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase - fails if google-services.json is missing
  // For development without credentials, set env var SKIP_FIREBASE_INIT=true
  final skipFirebase = const bool.fromEnvironment('SKIP_FIREBASE_INIT', defaultValue: false);
  
  if (!skipFirebase) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } on FirebaseException catch (e) {
      // Firebase configuration error - likely missing google-services.json
      final bool hasGoogleServices = e.message?.contains('google-services.json') ?? false;
      if (e.code == 'firebase-configuration-error' || hasGoogleServices) {
        debugPrint('Firebase configuration missing: ${e.message}');
        debugPrint('Set SKIP_FIREBASE_INIT=true to run without Firebase');
        rethrow;
      }
      // Other Firebase errors should crash the app
      rethrow;
    } catch (e) {
      // Any other initialization error - crash app
      debugPrint('Firebase initialization failed: $e');
      rethrow;
    }
  } else {
    debugPrint('Firebase initialization skipped (SKIP_FIREBASE_INIT=true)');
  }
  
  // Initialize background service - only when actually needed
  // Commented out to prevent crash on startup - will initialize on-demand
  // try {
  //   await initializeBackgroundService();
  // } catch (e) {
  //   debugPrint('Background service initialization failed: $e');
  // }
  try {
    await initializeBackgroundService();
  } catch (e) {
    debugPrint('Background service initialization failed: $e');
  }

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0B1120),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ZeldApp());
}

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: 'zelda_emergency_channel',
      initialNotificationTitle: 'ZELDA',
      initialNotificationContent: 'Emergency service is running',
      foregroundServiceNotificationId: 888,
      foregroundServiceTypes: [AndroidForegroundType.location],
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

/// Start the background service for location tracking
Future<void> startBackgroundService() async {
  final service = FlutterBackgroundService();
  await service.startService();
}

/// Stop the background service
Future<void> stopBackgroundService() async {
  final service = FlutterBackgroundService();
  service.invoke('stopService');
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  
  // Listen for start tracking command
  service.on('startTracking').listen((event) async {
    if (event != null && event['userId'] != null) {
      final locationService = LocationService();
      await locationService.startTracking(event['userId']);
    }
  });
  
  // Listen for stop tracking command
  service.on('stopTracking').listen((event) {
    final locationService = LocationService();
    locationService.stopTracking();
  });
  
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}

class ZeldApp extends StatelessWidget {
  const ZeldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => PermissionService()),
        Provider(create: (_) => LocationService()),
      ],
      child: MaterialApp.router(
        title: 'ZELDA',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
