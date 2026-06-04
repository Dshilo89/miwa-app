/// Coupon model for MIWA application
class Coupon {
  final String id;
  final String code;
  final String type; // percentage, fixed, free_delivery
  final double value;
  final double? minimumOrder;
  final double? maximumDiscount;
  final String? restaurantId;
  final int? usageLimit;
  final int usedCount;
  final DateTime validFrom;
  final DateTime validUntil;
  final bool isActive;
  final DateTime createdAt;

  Coupon({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
    this.minimumOrder,
    this.maximumDiscount,
    this.restaurantId,
    this.usageLimit,
    this.usedCount = 0,
    required this.validFrom,
    required this.validUntil,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Coupon.fromMap(Map<String, dynamic> data, String id) {
    return Coupon(
      id: id,
      code: data['code'] ?? '',
      type: data['type'] ?? 'percentage',
      value: (data['value'] ?? 0.0).toDouble(),
      minimumOrder: (data['minimumOrder'] as num?)?.toDouble(),
      maximumDiscount: (data['maximumDiscount'] as num?)?.toDouble(),
      restaurantId: data['restaurantId'],
      usageLimit: data['usageLimit'],
      usedCount: data['usedCount'] ?? 0,
      validFrom: (data['validFrom'] as dynamic)?.toDate() ?? DateTime.now(),
      validUntil: (data['validUntil'] as dynamic)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'type': type,
      'value': value,
      'minimumOrder': minimumOrder,
      'maximumDiscount': maximumDiscount,
      'restaurantId': restaurantId,
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'validFrom': validFrom,
      'validUntil': validUntil,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }

  bool get isValid {
    final now = DateTime.now();
    return isActive && now.isAfter(validFrom) && now.isBefore(validUntil) && (usageLimit == null || usedCount < usageLimit!);
  }

  double calculateDiscount(double subtotal) {
    if (minimumOrder != null && subtotal < minimumOrder!) return 0.0;
    double discount = 0;
    if (type == 'percentage') {
      discount = subtotal * (value / 100);
      if (maximumDiscount != null && discount > maximumDiscount!) discount = maximumDiscount!;
    } else if (type == 'fixed') {
      discount = value;
    } else if (type == 'free_delivery') {
      // Handled separately
      return 0;
    }
    return discount;
  }
}