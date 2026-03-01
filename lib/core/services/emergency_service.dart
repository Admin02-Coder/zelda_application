import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'location_service.dart';

/// Emergency status enum
enum EmergencyStatus {
  active,
  acknowledged,
  resolved,
  cancelled,
}

/// Model for emergency data
class EmergencyModel {
  final String id;
  final String userId;
  final String userName;
  final double latitude;
  final double longitude;
  final EmergencyStatus status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? policeId;
  final String? notes;
  final String triggerType; // 'manual' or 'voice'

  EmergencyModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
    this.policeId,
    this.notes,
    required this.triggerType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'latitude': latitude,
      'longitude': longitude,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
      'policeId': policeId,
      'notes': notes,
      'triggerType': triggerType,
    };
  }

  factory EmergencyModel.fromMap(Map<String, dynamic> map) {
    return EmergencyModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      status: EmergencyStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => EmergencyStatus.active,
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      resolvedAt: (map['resolvedAt'] as Timestamp?)?.toDate(),
      policeId: map['policeId'],
      notes: map['notes'],
      triggerType: map['triggerType'] ?? 'manual',
    );
  }
}

/// Service for handling emergency triggers and management
class EmergencyService {
  static final EmergencyService _instance = EmergencyService._internal();
  factory EmergencyService() => _instance;
  EmergencyService._internal();

  final LocationService _locationService = LocationService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isEmergencyActive = false;
  String? _currentEmergencyId;

  /// Trigger emergency
  Future<String?> triggerEmergency({
    required String userId,
    required String userName,
    String triggerType = 'manual',
  }) async {
    if (_isEmergencyActive) return null;

    // Get current location
    final position = await _locationService.getCurrentPosition();
    if (position == null) return null;

    // Create emergency document
    final emergencyRef = _firestore.collection('emergencies').doc();
    final emergency = EmergencyModel(
      id: emergencyRef.id,
      userId: userId,
      userName: userName,
      latitude: position.latitude,
      longitude: position.longitude,
      status: EmergencyStatus.active,
      createdAt: DateTime.now(),
      triggerType: triggerType,
    );

    await emergencyRef.set(emergency.toMap());

    // Update user's emergency status
    await _firestore.collection('users').doc(userId).set({
      'hasActiveEmergency': true,
      'currentEmergencyId': emergencyRef.id,
    }, SetOptions(merge: true));

    _isEmergencyActive = true;
    _currentEmergencyId = emergencyRef.id;

    // Start location tracking for emergency
    await _locationService.startTracking(userId);

    return emergencyRef.id;
  }

  /// Cancel emergency
  Future<void> cancelEmergency(String userId) async {
    if (!_isEmergencyActive) return;

    // Update emergency status
    if (_currentEmergencyId != null) {
      await _firestore.collection('emergencies').doc(_currentEmergencyId).update({
        'status': EmergencyStatus.cancelled.name,
        'resolvedAt': Timestamp.fromDate(DateTime.now()),
      });
    }

    // Update user status
    await _firestore.collection('users').doc(userId).set({
      'hasActiveEmergency': false,
      'currentEmergencyId': null,
    }, SetOptions(merge: true));

    // Stop location tracking
    _locationService.stopTracking();

    _isEmergencyActive = false;
    _currentEmergencyId = null;
  }

  /// Acknowledge emergency (Police action)
  Future<void> acknowledgeEmergency(String emergencyId, String policeId) async {
    await _firestore.collection('emergencies').doc(emergencyId).update({
      'status': EmergencyStatus.acknowledged.name,
      'policeId': policeId,
      'acknowledgedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  /// Resolve emergency (Police action)
  Future<void> resolveEmergency(String emergencyId, {String? notes}) async {
    await _firestore.collection('emergencies').doc(emergencyId).update({
      'status': EmergencyStatus.resolved.name,
      'resolvedAt': Timestamp.fromDate(DateTime.now()),
      'notes': notes,
    });

    // If this was the current emergency, reset
    if (_currentEmergencyId == emergencyId) {
      _isEmergencyActive = false;
      _currentEmergencyId = null;
    }
  }

  /// Get active emergencies stream
  Stream<List<EmergencyModel>> getActiveEmergencies() {
    return _firestore
        .collection('emergencies')
        .where('status', whereIn: [EmergencyStatus.active.name, EmergencyStatus.acknowledged.name])
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EmergencyModel.fromMap(doc.data()))
            .toList());
  }

  /// Get emergency history for a user
  Stream<List<EmergencyModel>> getEmergencyHistory(String userId) {
    return _firestore
        .collection('emergencies')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EmergencyModel.fromMap(doc.data()))
            .toList());
  }

  /// Check if emergency is active
  bool get isEmergencyActive => _isEmergencyActive;

  /// Get current emergency ID
  String? get currentEmergencyId => _currentEmergencyId;
}
