/// Notification model for MIWA application
class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String? data;
  final String type; // order, donation, promo, campaign, system
  final bool isRead;
  final String? imageUrl;
  final String? actionRoute;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.data,
    this.type = 'system',
    this.isRead = false,
    this.imageUrl,
    this.actionRoute,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AppNotification.fromMap(Map<String, dynamic> data, String id) {
    return AppNotification(
      id: id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      data: data['data'],
      type: data['type'] ?? 'system',
      isRead: data['isRead'] ?? false,
      imageUrl: data['imageUrl'],
      actionRoute: data['actionRoute'],
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'data': data,
      'type': type,
      'isRead': isRead,
      'imageUrl': imageUrl,
      'actionRoute': actionRoute,
      'createdAt': createdAt,
    };
  }
}