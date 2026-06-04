/// User model for MIWA application
/// Represents customers, riders, restaurant owners, and admins
class UserModel {
  final String id;
  final String email;
  final String phone;
  final String fullName;
  final String? photoUrl;
  final String role; // customer, rider, restaurant, admin
  final bool isVerified;
  final bool isActive;
  final String? fcmToken;
  final Address? defaultAddress;
  final List<Address> savedAddresses;
  final int loyaltyPoints;
  final String? referralCode;
  final String? referredBy;
  final Map<String, dynamic>? preferences;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.fullName,
    this.photoUrl,
    this.role = 'customer',
    this.isVerified = false,
    this.isActive = true,
    this.fcmToken,
    this.defaultAddress,
    this.savedAddresses = const [],
    this.loyaltyPoints = 0,
    this.referralCode,
    this.referredBy,
    this.preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  /// Create from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      fullName: data['fullName'] ?? '',
      photoUrl: data['photoUrl'],
      role: data['role'] ?? 'customer',
      isVerified: data['isVerified'] ?? false,
      isActive: data['isActive'] ?? true,
      fcmToken: data['fcmToken'],
      defaultAddress: data['defaultAddress'] != null
          ? Address.fromMap(data['defaultAddress'])
          : null,
      savedAddresses: data['savedAddresses'] != null
          ? (data['savedAddresses'] as List)
              .map((e) => Address.fromMap(e))
              .toList()
          : [],
      loyaltyPoints: data['loyaltyPoints'] ?? 0,
      referralCode: data['referralCode'],
      referredBy: data['referredBy'],
      preferences: data['preferences'],
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phone': phone,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'role': role,
      'isVerified': isVerified,
      'isActive': isActive,
      'fcmToken': fcmToken,
      'defaultAddress': defaultAddress?.toMap(),
      'savedAddresses': savedAddresses.map((e) => e.toMap()).toList(),
      'loyaltyPoints': loyaltyPoints,
      'referralCode': referralCode,
      'referredBy': referredBy,
      'preferences': preferences,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Copy with updated fields
  UserModel copyWith({
    String? email,
    String? phone,
    String? fullName,
    String? photoUrl,
    String? role,
    bool? isVerified,
    bool? isActive,
    String? fcmToken,
    Address? defaultAddress,
    List<Address>? savedAddresses,
    int? loyaltyPoints,
    String? referralCode,
    String? referredBy,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      id: id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      fcmToken: fcmToken ?? this.fcmToken,
      defaultAddress: defaultAddress ?? this.defaultAddress,
      savedAddresses: savedAddresses ?? this.savedAddresses,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      referralCode: referralCode ?? this.referralCode,
      referredBy: referredBy ?? this.referredBy,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  String get initials {
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }
}

/// Address model
class Address {
  final String id;
  final String label;
  final String street;
  final String? city;
  final String? state;
  final String? zipCode;
  final double latitude;
  final double longitude;
  final bool isDefault;
  final String? additionalDetails;

  Address({
    required this.id,
    required this.label,
    required this.street,
    this.city,
    this.state,
    this.zipCode,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
    this.additionalDetails,
  });

  factory Address.fromMap(Map<String, dynamic> data) {
    return Address(
      id: data['id'] ?? '',
      label: data['label'] ?? 'Home',
      street: data['street'] ?? '',
      city: data['city'],
      state: data['state'],
      zipCode: data['zipCode'],
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      isDefault: data['isDefault'] ?? false,
      additionalDetails: data['additionalDetails'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
      'additionalDetails': additionalDetails,
    };
  }

  String get formattedAddress => '$street${city != null ? ', $city' : ''}${state != null ? ', $state' : ''}';
}