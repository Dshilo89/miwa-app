/// Review model for MIWA application
class Review {
  final String id;
  final String userId;
  final String? userName;
  final String? userPhotoUrl;
  final String targetId; // restaurantId or riderId
  final String targetType; // restaurant, rider, menu_item
  final double rating;
  final String? comment;
  final List<String>? images;
  final String? orderId;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    this.userName,
    this.userPhotoUrl,
    required this.targetId,
    required this.targetType,
    required this.rating,
    this.comment,
    this.images,
    this.orderId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Review.fromMap(Map<String, dynamic> data, String id) {
    return Review(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'],
      userPhotoUrl: data['userPhotoUrl'],
      targetId: data['targetId'] ?? '',
      targetType: data['targetType'] ?? 'restaurant',
      rating: (data['rating'] ?? 0.0).toDouble(),
      comment: data['comment'],
      images: data['images'] != null ? List<String>.from(data['images']) : null,
      orderId: data['orderId'],
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'targetId': targetId,
      'targetType': targetType,
      'rating': rating,
      'comment': comment,
      'images': images,
      'orderId': orderId,
      'createdAt': createdAt,
    };
  }
}