/// Referral model for MIWA application
class Referral {
  final String id;
  final String referrerId;
  final String? referredUserId;
  final String? referredEmail;
  final String? referredPhone;
  final String status; // pending, joined, rewarded
  final double? rewardAmount;
  final int? rewardPoints;
  final DateTime createdAt;
  final DateTime? joinedAt;

  Referral({
    required this.id,
    required this.referrerId,
    this.referredUserId,
    this.referredEmail,
    this.referredPhone,
    this.status = 'pending',
    this.rewardAmount,
    this.rewardPoints,
    DateTime? createdAt,
    this.joinedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Referral.fromMap(Map<String, dynamic> data, String id) {
    return Referral(
      id: id,
      referrerId: data['referrerId'] ?? '',
      referredUserId: data['referredUserId'],
      referredEmail: data['referredEmail'],
      referredPhone: data['referredPhone'],
      status: data['status'] ?? 'pending',
      rewardAmount: (data['rewardAmount'] as num?)?.toDouble(),
      rewardPoints: data['rewardPoints'],
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      joinedAt: (data['joinedAt'] as dynamic)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'referrerId': referrerId,
      'referredUserId': referredUserId,
      'referredEmail': referredEmail,
      'referredPhone': referredPhone,
      'status': status,
      'rewardAmount': rewardAmount,
      'rewardPoints': rewardPoints,
      'createdAt': createdAt,
      'joinedAt': joinedAt,
    };
  }
}