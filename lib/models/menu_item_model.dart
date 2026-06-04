/// Menu item model for MIWA application
class MenuItem {
  final String id;
  final String restaurantId;
  final String categoryId;
  final String name;
  final String? description;
  final String? imageUrl;
  final double price;
  final double? discountPrice;
  final String currency;
  final bool isAvailable;
  final bool isPopular;
  final bool isDonationEligible;
  final List<String> ingredients;
  final List<String> dietaryTags; // vegan, gluten-free, etc.
  final List<MenuOption> options;
  final int preparationTime;
  final int orderCount;
  final double rating;
  final DateTime createdAt;

  MenuItem({
    required this.id,
    required this.restaurantId,
    required this.categoryId,
    required this.name,
    this.description,
    this.imageUrl,
    required this.price,
    this.discountPrice,
    this.currency = 'NGN',
    this.isAvailable = true,
    this.isPopular = false,
    this.isDonationEligible = false,
    this.ingredients = const [],
    this.dietaryTags = const [],
    this.options = const [],
    this.preparationTime = 10,
    this.orderCount = 0,
    this.rating = 0.0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory MenuItem.fromMap(Map<String, dynamic> data, String id) {
    return MenuItem(
      id: id,
      restaurantId: data['restaurantId'] ?? '',
      categoryId: data['categoryId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'],
      imageUrl: data['imageUrl'],
      price: (data['price'] ?? 0.0).toDouble(),
      discountPrice: (data['discountPrice'] as num?)?.toDouble(),
      currency: data['currency'] ?? 'NGN',
      isAvailable: data['isAvailable'] ?? true,
      isPopular: data['isPopular'] ?? false,
      isDonationEligible: data['isDonationEligible'] ?? false,
      ingredients: List<String>.from(data['ingredients'] ?? []),
      dietaryTags: List<String>.from(data['dietaryTags'] ?? []),
      options: data['options'] != null
          ? (data['options'] as List).map((e) => MenuOption.fromMap(e)).toList()
          : [],
      preparationTime: data['preparationTime'] ?? 10,
      orderCount: data['orderCount'] ?? 0,
      rating: (data['rating'] ?? 0.0).toDouble(),
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'discountPrice': discountPrice,
      'currency': currency,
      'isAvailable': isAvailable,
      'isPopular': isPopular,
      'isDonationEligible': isDonationEligible,
      'ingredients': ingredients,
      'dietaryTags': dietaryTags,
      'options': options.map((e) => e.toMap()).toList(),
      'preparationTime': preparationTime,
      'orderCount': orderCount,
      'rating': rating,
      'createdAt': createdAt,
    };
  }

  double get effectivePrice => discountPrice ?? price;
  bool get hasDiscount => discountPrice != null && discountPrice! < price;
}

/// Menu option (e.g., size, extras)
class MenuOption {
  final String name;
  final bool required;
  final List<MenuOptionChoice> choices;

  MenuOption({
    required this.name,
    this.required = false,
    this.choices = const [],
  });

  factory MenuOption.fromMap(Map<String, dynamic> data) {
    return MenuOption(
      name: data['name'] ?? '',
      required: data['required'] ?? false,
      choices: data['choices'] != null
          ? (data['choices'] as List).map((e) => MenuOptionChoice.fromMap(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'required': required,
      'choices': choices.map((e) => e.toMap()).toList(),
    };
  }
}

/// Menu option choice
class MenuOptionChoice {
  final String name;
  final double price;

  MenuOptionChoice({
    required this.name,
    this.price = 0.0,
  });

  factory MenuOptionChoice.fromMap(Map<String, dynamic> data) {
    return MenuOptionChoice(
      name: data['name'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }
}