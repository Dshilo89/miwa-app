/// Cart model for MIWA application
class Cart {
  final String id;
  final String userId;
  final String? restaurantId;
  final String? restaurantName;
  final String? restaurantPhotoUrl;
  final List<CartItem> items;
  final double deliveryFee;
  final double serviceFee;
  final double tip;
  final double donationAmount;
  final double discount;
  final String? couponCode;

  Cart({
    required this.id,
    required this.userId,
    this.restaurantId,
    this.restaurantName,
    this.restaurantPhotoUrl,
    this.items = const [],
    this.deliveryFee = 0.0,
    this.serviceFee = 0.0,
    this.tip = 0.0,
    this.donationAmount = 0.0,
    this.discount = 0.0,
    this.couponCode,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get total => (subtotal + deliveryFee + serviceFee + tip + donationAmount - discount).clamp(0.0, double.infinity);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;
  bool get isFromSameRestaurant => items.every((item) => item.restaurantId == (restaurantId ?? items.first.restaurantId));

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'restaurantPhotoUrl': restaurantPhotoUrl,
      'items': items.map((e) => e.toMap()).toList(),
      'deliveryFee': deliveryFee,
      'serviceFee': serviceFee,
      'tip': tip,
      'donationAmount': donationAmount,
      'discount': discount,
      'couponCode': couponCode,
    };
  }
}

/// Cart item
class CartItem {
  final String menuItemId;
  final String restaurantId;
  final String name;
  final String? imageUrl;
  final double price;
  final int quantity;
  final List<String> selectedOptions;
  final String? specialInstructions;

  CartItem({
    required this.menuItemId,
    required this.restaurantId,
    required this.name,
    this.imageUrl,
    required this.price,
    this.quantity = 1,
    this.selectedOptions = const [],
    this.specialInstructions,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({int? quantity, String? specialInstructions, List<String>? selectedOptions}) {
    return CartItem(
      menuItemId: menuItemId,
      restaurantId: restaurantId,
      name: name,
      imageUrl: imageUrl,
      price: price,
      quantity: quantity ?? this.quantity,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'menuItemId': menuItemId,
      'restaurantId': restaurantId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'selectedOptions': selectedOptions,
      'specialInstructions': specialInstructions,
    };
  }
}