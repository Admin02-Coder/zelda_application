/// User role enum
enum UserRole {
  citizen,
  police,
}

/// User model for Firebase
class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final UserRole role;
  final bool isVerified;
  final bool hasActiveEmergency;
  final String? currentEmergencyId;
  final DateTime createdAt;
  final List<String> trustedContacts;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.role = UserRole.citizen,
    this.isVerified = false,
    this.hasActiveEmergency = false,
    this.currentEmergencyId,
    required this.createdAt,
    this.trustedContacts = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role.name,
      'isVerified': isVerified,
      'hasActiveEmergency': hasActiveEmergency,
      'currentEmergencyId': currentEmergencyId,
      'createdAt': createdAt.toIso8601String(),
      'trustedContacts': trustedContacts,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.citizen,
      ),
      isVerified: map['isVerified'] ?? false,
      hasActiveEmergency: map['hasActiveEmergency'] ?? false,
      currentEmergencyId: map['currentEmergencyId'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      trustedContacts: List<String>.from(map['trustedContacts'] ?? []),
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    UserRole? role,
    bool? isVerified,
    bool? hasActiveEmergency,
    String? currentEmergencyId,
    DateTime? createdAt,
    List<String>? trustedContacts,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      hasActiveEmergency: hasActiveEmergency ?? this.hasActiveEmergency,
      currentEmergencyId: currentEmergencyId ?? this.currentEmergencyId,
      createdAt: createdAt ?? this.createdAt,
      trustedContacts: trustedContacts ?? this.trustedContacts,
    );
  }

  bool get isPolice => role == UserRole.police;
}
