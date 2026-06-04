import 'user_model.dart';

/// Restaurant model for MIWA application
class Restaurant {
  final String id;
  final String name;
  final String? description;
  final String? photoUrl;
  final String? coverPhotoUrl;
  final String phone;
  final String email;
  final Address address;
  final List<String> cuisineTypes;
  final List<String> menuCategoryIds;
  final double rating;
  final int totalReviews;
  final double deliveryFee;
  final double minimumOrder;
  final double? deliveryRadius;
  final bool isOpen;
  final bool isVerified;
  final bool isActive;
  final bool acceptsDonations;
  final Map<String, dynamic> operatingHours;
  final Map<String, dynamic>? location;
  final int preparationTime; // in minutes
  final List<String>? promotions;
  final DateTime createdAt;
  final DateTime updatedAt;

  Restaurant({
    required this.id,
    required this.name,
    this.description,
    this.photoUrl,
    this.coverPhotoUrl,
    required this.phone,
    required this.email,
    required this.address,
    this.cuisineTypes = const [],
    this.menuCategoryIds = const [],
    this.rating = 0.0,
    this.totalReviews = 0,
    this.deliveryFee = 0.0,
    this.minimumOrder = 0.0,
    this.deliveryRadius,
    this.isOpen = false,
    this.isVerified = false,
    this.isActive = true,
    this.acceptsDonations = false,
    this.operatingHours = const {},
    this.location,
    this.preparationTime = 20,
    this.promotions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Restaurant.fromMap(Map<String, dynamic> data, String id) {
    return Restaurant(
      id: id,
      name: data['name'] ?? '',
      description: data['description'],
      photoUrl: data['photoUrl'],
      coverPhotoUrl: data['coverPhotoUrl'],
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      address: data['address'] != null
          ? Address.fromMap(data['address'])
          : Address(id: '', label: '', street: '', latitude: 0, longitude: 0),
      cuisineTypes: List<String>.from(data['cuisineTypes'] ?? []),
      menuCategoryIds: List<String>.from(data['menuCategoryIds'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
      deliveryFee: (data['deliveryFee'] ?? 0.0).toDouble(),
      minimumOrder: (data['minimumOrder'] ?? 0.0).toDouble(),
      deliveryRadius: (data['deliveryRadius'] as num?)?.toDouble(),
      isOpen: data['isOpen'] ?? false,
      isVerified: data['isVerified'] ?? false,
      isActive: data['isActive'] ?? true,
      acceptsDonations: data['acceptsDonations'] ?? false,
      operatingHours: data['operatingHours'] ?? {},
      location: data['location'],
      preparationTime: data['preparationTime'] ?? 20,
      promotions: data['promotions'] != null
          ? List<String>.from(data['promotions'])
          : null,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
      'coverPhotoUrl': coverPhotoUrl,
      'phone': phone,
      'email': email,
      'address': address.toMap(),
      'cuisineTypes': cuisineTypes,
      'menuCategoryIds': menuCategoryIds,
      'rating': rating,
      'totalReviews': totalReviews,
      'deliveryFee': deliveryFee,
      'minimumOrder': minimumOrder,
      'deliveryRadius': deliveryRadius,
      'isOpen': isOpen,
      'isVerified': isVerified,
      'isActive': isActive,
      'acceptsDonations': acceptsDonations,
      'operatingHours': operatingHours,
      'location': location,
      'preparationTime': preparationTime,
      'promotions': promotions,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}