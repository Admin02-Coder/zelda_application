import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Permission Service - Manages all app permissions
class PermissionService {
  static const String _locationPermissionKey = 'location_permission_requested';
  static const String _microphonePermissionKey = 'microphone_permission_requested';
  static const String _onboardingCompleteKey = 'onboarding_complete';

  /// Check if location permission has been granted
  Future<bool> isLocationGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Check if microphone permission has been granted
  Future<bool> isMicrophoneGranted() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  /// Request location permission
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    
    if (status.isGranted) {
      // Save that we've requested this permission
      await _saveLocationPermissionRequested();
      return true;
    }
    return false;
  }

  /// Request microphone permission
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    
    if (status.isGranted) {
      // Save that we've requested this permission
      await _saveMicrophonePermissionRequested();
      return true;
    }
    return false;
  }

  /// Check if location permission has been permanently denied
  Future<bool> isLocationPermanentlyDenied() async {
    final status = await Permission.location.status;
    return status.isPermanentlyDenied;
  }

  /// Check if microphone permission has been permanently denied
  Future<bool> isMicrophonePermanentlyDenied() async {
    final status = await Permission.microphone.status;
    return status.isPermanentlyDenied;
  }

  /// Open app settings for user to manually enable permission
  Future<bool> openSettings() async {
    return await openAppSettings();
  }

  /// Check if onboarding is complete
  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  /// Mark onboarding as complete
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
  }

  /// Check if location permission was already requested
  Future<bool> wasLocationPermissionRequested() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_locationPermissionKey) ?? false;
  }

  /// Check if microphone permission was already requested
  Future<bool> wasMicrophonePermissionRequested() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_microphonePermissionKey) ?? false;
  }

  /// Request all permissions for first launch
  Future<void> requestAllPermissions() async {
    // Request location permission
    await requestLocationPermission();
    
    // Request microphone permission
    await requestMicrophonePermission();
  }

  // Private methods to save permission states
  Future<void> _saveLocationPermissionRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_locationPermissionKey, true);
  }

  Future<void> _saveMicrophonePermissionRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_microphonePermissionKey, true);
  }
}
