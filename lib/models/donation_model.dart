/// Donation model for MIWA application
class Donation {
  final String id;
  final String userId;
  final String? userName;
  final String? userPhotoUrl;
  final String type; // meal, money, sponsorship
  final double amount;
  final int mealCount;
  final String? campaignId;
  final String? campaignName;
  final String? restaurantId;
  final String? restaurantName;
  final bool isAnonymous;
  final bool isCorporate;
  final String? corporateName;
  final String status; // pending, completed, failed
  final String? message;
  final String? paymentMethod;
  final bool isFeedVisible;
  final DateTime createdAt;

  Donation({
    required this.id,
    required this.userId,
    this.userName,
    this.userPhotoUrl,
    required this.type,
    required this.amount,
    this.mealCount = 0,
    this.campaignId,
    this.campaignName,
    this.restaurantId,
    this.restaurantName,
    this.isAnonymous = false,
    this.isCorporate = false,
    this.corporateName,
    this.status = 'completed',
    this.message,
    this.paymentMethod,
    this.isFeedVisible = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Donation.fromMap(Map<String, dynamic> data, String id) {
    return Donation(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'],
      userPhotoUrl: data['userPhotoUrl'],
      type: data['type'] ?? 'money',
      amount: (data['amount'] ?? 0.0).toDouble(),
      mealCount: data['mealCount'] ?? 0,
      campaignId: data['campaignId'],
      campaignName: data['campaignName'],
      restaurantId: data['restaurantId'],
      restaurantName: data['restaurantName'],
      isAnonymous: data['isAnonymous'] ?? false,
      isCorporate: data['isCorporate'] ?? false,
      corporateName: data['corporateName'],
      status: data['status'] ?? 'completed',
      message: data['message'],
      paymentMethod: data['paymentMethod'],
      isFeedVisible: data['isFeedVisible'] ?? true,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'type': type,
      'amount': amount,
      'mealCount': mealCount,
      'campaignId': campaignId,
      'campaignName': campaignName,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'isAnonymous': isAnonymous,
      'isCorporate': isCorporate,
      'corporateName': corporateName,
      'status': status,
      'message': message,
      'paymentMethod': paymentMethod,
      'isFeedVisible': isFeedVisible,
      'createdAt': createdAt,
    };
  }

  /// For the live social feed, generate a display text
  String get feedText {
    if (isAnonymous) {
      if (type == 'meal') return 'Someone donated $mealCount meals';
      return 'Someone donated ₦${amount.toStringAsFixed(0)}';
    }
    if (isCorporate && corporateName != null) {
      if (type == 'meal') return '$corporateName sponsored $mealCount meals';
      return '$corporateName donated ₦${amount.toStringAsFixed(0)}';
    }
    final name = userName ?? 'A user';
    if (type == 'meal') return '$name donated $mealCount meals';
    return '$name donated ₦${amount.toStringAsFixed(0)}';
  }
}