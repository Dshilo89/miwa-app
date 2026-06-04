/// Category model for MIWA application
class FoodCategory {
  final String id;
  final String name;
  final String? imageUrl;
  final String? iconName;
  final String? description;
  final int order;
  final bool isActive;
  final DateTime createdAt;

  FoodCategory({
    required this.id,
    required this.name,
    this.imageUrl,
    this.iconName,
    this.description,
    this.order = 0,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory FoodCategory.fromMap(Map<String, dynamic> data, String id) {
    return FoodCategory(
      id: id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'],
      iconName: data['iconName'],
      description: data['description'],
      order: data['order'] ?? 0,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'iconName': iconName,
      'description': description,
      'order': order,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }
}