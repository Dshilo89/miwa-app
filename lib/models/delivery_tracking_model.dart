/// Delivery tracking model for MIWA application
class DeliveryTracking {
  final String orderId;
  final String? riderId;
  final String? riderName;
  final String? riderPhone;
  final String? riderPhotoUrl;
  final double? riderLatitude;
  final double? riderLongitude;
  final double? restaurantLatitude;
  final double? restaurantLongitude;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final String status;
  final DateTime? pickupTime;
  final DateTime? estimatedDeliveryTime;
  final DateTime? deliveredAt;
  final String? otpCode;
  final List<TrackingUpdate> updates;

  DeliveryTracking({
    required this.orderId,
    this.riderId,
    this.riderName,
    this.riderPhone,
    this.riderPhotoUrl,
    this.riderLatitude,
    this.riderLongitude,
    this.restaurantLatitude,
    this.restaurantLongitude,
    this.destinationLatitude,
    this.destinationLongitude,
    this.status = 'pending',
    this.pickupTime,
    this.estimatedDeliveryTime,
    this.deliveredAt,
    this.otpCode,
    this.updates = const [],
  });

  factory DeliveryTracking.fromMap(Map<String, dynamic> data) {
    return DeliveryTracking(
      orderId: data['orderId'] ?? '',
      riderId: data['riderId'],
      riderName: data['riderName'],
      riderPhone: data['riderPhone'],
      riderPhotoUrl: data['riderPhotoUrl'],
      riderLatitude: (data['riderLatitude'] as num?)?.toDouble(),
      riderLongitude: (data['riderLongitude'] as num?)?.toDouble(),
      restaurantLatitude: (data['restaurantLatitude'] as num?)?.toDouble(),
      restaurantLongitude: (data['restaurantLongitude'] as num?)?.toDouble(),
      destinationLatitude: (data['destinationLatitude'] as num?)?.toDouble(),
      destinationLongitude: (data['destinationLongitude'] as num?)?.toDouble(),
      status: data['status'] ?? 'pending',
      pickupTime: (data['pickupTime'] as dynamic)?.toDate(),
      estimatedDeliveryTime: (data['estimatedDeliveryTime'] as dynamic)?.toDate(),
      deliveredAt: (data['deliveredAt'] as dynamic)?.toDate(),
      otpCode: data['otpCode'],
      updates: data['updates'] != null
          ? (data['updates'] as List).map((e) => TrackingUpdate.fromMap(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'riderId': riderId,
      'riderName': riderName,
      'riderPhone': riderPhone,
      'riderPhotoUrl': riderPhotoUrl,
      'riderLatitude': riderLatitude,
      'riderLongitude': riderLongitude,
      'restaurantLatitude': restaurantLatitude,
      'restaurantLongitude': restaurantLongitude,
      'destinationLatitude': destinationLatitude,
      'destinationLongitude': destinationLongitude,
      'status': status,
      'pickupTime': pickupTime,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'deliveredAt': deliveredAt,
      'otpCode': otpCode,
      'updates': updates.map((e) => e.toMap()).toList(),
    };
  }
}

/// Tracking update
class TrackingUpdate {
  final String status;
  final String? message;
  final String? location;
  final DateTime timestamp;

  TrackingUpdate({
    required this.status,
    this.message,
    this.location,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory TrackingUpdate.fromMap(Map<String, dynamic> data) {
    return TrackingUpdate(
      status: data['status'] ?? '',
      message: data['message'],
      location: data['location'],
      timestamp: (data['timestamp'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'location': location,
      'timestamp': timestamp,
    };
  }
}