/// Rider model for MIWA application
class Rider {
  final String id;
  final String userId;
  final String fullName;
  final String? photoUrl;
  final String phone;
  final String email;
  final String vehicleType; // bike, car, scooter
  final String? vehicleNumber;
  final String? licenseNumber;
  final bool isOnline;
  final bool isActive;
  final bool isVerified;
  final double rating;
  final int totalDeliveries;
  final int totalEarnings;
  final int todayDeliveries;
  final double todayEarnings;
  final double? currentLatitude;
  final double? currentLongitude;
  final String status; // available, busy, offline
  final List<String>? deliveryZones;
  final DateTime createdAt;

  Rider({
    required this.id,
    required this.userId,
    required this.fullName,
    this.photoUrl,
    required this.phone,
    required this.email,
    required this.vehicleType,
    this.vehicleNumber,
    this.licenseNumber,
    this.isOnline = false,
    this.isActive = true,
    this.isVerified = false,
    this.rating = 5.0,
    this.totalDeliveries = 0,
    this.totalEarnings = 0,
    this.todayDeliveries = 0,
    this.todayEarnings = 0.0,
    this.currentLatitude,
    this.currentLongitude,
    this.status = 'offline',
    this.deliveryZones,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Rider.fromMap(Map<String, dynamic> data, String id) {
    return Rider(
      id: id,
      userId: data['userId'] ?? '',
      fullName: data['fullName'] ?? '',
      photoUrl: data['photoUrl'],
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      vehicleType: data['vehicleType'] ?? 'bike',
      vehicleNumber: data['vehicleNumber'],
      licenseNumber: data['licenseNumber'],
      isOnline: data['isOnline'] ?? false,
      isActive: data['isActive'] ?? true,
      isVerified: data['isVerified'] ?? false,
      rating: (data['rating'] ?? 5.0).toDouble(),
      totalDeliveries: data['totalDeliveries'] ?? 0,
      totalEarnings: data['totalEarnings'] ?? 0,
      todayDeliveries: data['todayDeliveries'] ?? 0,
      todayEarnings: (data['todayEarnings'] ?? 0.0).toDouble(),
      currentLatitude: (data['currentLatitude'] as num?)?.toDouble(),
      currentLongitude: (data['currentLongitude'] as num?)?.toDouble(),
      status: data['status'] ?? 'offline',
      deliveryZones: data['deliveryZones'] != null
          ? List<String>.from(data['deliveryZones'])
          : null,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'phone': phone,
      'email': email,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'licenseNumber': licenseNumber,
      'isOnline': isOnline,
      'isActive': isActive,
      'isVerified': isVerified,
      'rating': rating,
      'totalDeliveries': totalDeliveries,
      'totalEarnings': totalEarnings,
      'todayDeliveries': todayDeliveries,
      'todayEarnings': todayEarnings,
      'currentLatitude': currentLatitude,
      'currentLongitude': currentLongitude,
      'status': status,
      'deliveryZones': deliveryZones,
      'createdAt': createdAt,
    };
  }
}