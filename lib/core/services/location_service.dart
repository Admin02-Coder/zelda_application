import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for handling location tracking and streaming to Firestore
class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  StreamSubscription<Position>? _positionSubscription;
  bool _isTracking = false;
  String? _currentUserId;
  Timer? _locationUpdateTimer;

  // Location update interval (15 seconds for Firestore free tier optimization)
  static const Duration _updateInterval = Duration(seconds: 15);

  /// Check and request location permissions
  Future<bool> checkAndRequestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// Start location tracking
  Future<bool> startTracking(String userId) async {
    if (_isTracking) return true;

    final hasPermission = await checkAndRequestPermission();
    if (!hasPermission) return false;

    _currentUserId = userId;
    _isTracking = true;

    // Get initial position
    final position = await getCurrentPosition();
    if (position != null) {
      await _updateLocationInFirestore(position);
    }

    // Set up periodic updates
    _locationUpdateTimer = Timer.periodic(_updateInterval, (_) async {
      final pos = await getCurrentPosition();
      if (pos != null) {
        await _updateLocationInFirestore(pos);
      }
    });

    return true;
  }

  /// Stop location tracking
  void stopTracking() {
    _isTracking = false;
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = null;
    _currentUserId = null;
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  /// Update location in Firestore
  Future<void> _updateLocationInFirestore(Position position) async {
    if (_currentUserId == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUserId)
          .collection('location')
          .doc('current')
          .set({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
        'altitude': position.altitude,
        'speed': position.speed,
        'heading': position.heading,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      // Handle Firestore write limit
    }
  }

  /// Get location stream for real-time updates
  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }

  /// Check if currently tracking
  bool get isTracking => _isTracking;
}
