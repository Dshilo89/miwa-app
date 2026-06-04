import 'user_model.dart';
import 'restaurant_model.dart';
import 'menu_item_model.dart';
import 'delivery_tracking_model.dart';

/// Order model for MIWA application
class Order {
  final String id;
  final String userId;
  final String? restaurantId;
  final String? riderId;
  final String orderNumber;
  final List<OrderItem> items;
  final Address deliveryAddress;
  final String? restaurantName;
  final String? restaurantPhoto;
  final String status; // pending, confirmed, preparing, ready, picked_up, in_transit, delivered, cancelled
  final String paymentMethod;
  final String paymentStatus; // pending, completed, failed, refunded
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double tip;
  final double discount;
  final double donationAmount;
  final double total;
  final String? couponCode;
  final bool isDonation;
  final String? donationId;
  final String? notes;
  final DeliveryTracking? tracking;
  final Map<String, dynamic>? paymentDetails;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deliveredAt;

  Order({
    required this.id,
    required this.userId,
    this.restaurantId,
    this.riderId,
    required this.orderNumber,
    required this.items,
    required this.deliveryAddress,
    this.restaurantName,
    this.restaurantPhoto,
    this.status = 'pending',
    this.paymentMethod = 'cash',
    this.paymentStatus = 'pending',
    this.subtotal = 0.0,
    this.deliveryFee = 0.0,
    this.serviceFee = 0.0,
    this.tip = 0.0,
    this.discount = 0.0,
    this.donationAmount = 0.0,
    this.total = 0.0,
    this.couponCode,
    this.isDonation = false,
    this.donationId,
    this.notes,
    this.tracking,
    this.paymentDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.deliveredAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Order.fromMap(Map<String, dynamic> data, String id) {
    return Order(
      id: id,
      userId: data['userId'] ?? '',
      restaurantId: data['restaurantId'],
      riderId: data['riderId'],
      orderNumber: data['orderNumber'] ?? '',
      items: data['items'] != null
          ? (data['items'] as List).map((e) => OrderItem.fromMap(e)).toList()
          : [],
      deliveryAddress: data['deliveryAddress'] != null
          ? Address.fromMap(data['deliveryAddress'])
          : Address(id: '', label: '', street: '', latitude: 0, longitude: 0),
      restaurantName: data['restaurantName'],
      restaurantPhoto: data['restaurantPhoto'],
      status: data['status'] ?? 'pending',
      paymentMethod: data['paymentMethod'] ?? 'cash',
      paymentStatus: data['paymentStatus'] ?? 'pending',
      subtotal: (data['subtotal'] ?? 0.0).toDouble(),
      deliveryFee: (data['deliveryFee'] ?? 0.0).toDouble(),
      serviceFee: (data['serviceFee'] ?? 0.0).toDouble(),
      tip: (data['tip'] ?? 0.0).toDouble(),
      discount: (data['discount'] ?? 0.0).toDouble(),
      donationAmount: (data['donationAmount'] ?? 0.0).toDouble(),
      total: (data['total'] ?? 0.0).toDouble(),
      couponCode: data['couponCode'],
      isDonation: data['isDonation'] ?? false,
      donationId: data['donationId'],
      notes: data['notes'],
      tracking: data['tracking'] != null
          ? DeliveryTracking.fromMap(data['tracking'])
          : null,
      paymentDetails: data['paymentDetails'],
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as dynamic)?.toDate() ?? DateTime.now(),
      deliveredAt: (data['deliveredAt'] as dynamic)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'restaurantId': restaurantId,
      'riderId': riderId,
      'orderNumber': orderNumber,
      'items': items.map((e) => e.toMap()).toList(),
      'deliveryAddress': deliveryAddress.toMap(),
      'restaurantName': restaurantName,
      'restaurantPhoto': restaurantPhoto,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'serviceFee': serviceFee,
      'tip': tip,
      'discount': discount,
      'donationAmount': donationAmount,
      'total': total,
      'couponCode': couponCode,
      'isDonation': isDonation,
      'donationId': donationId,
      'notes': notes,
      'tracking': tracking?.toMap(),
      'paymentDetails': paymentDetails,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deliveredAt': deliveredAt,
    };
  }

  String get statusLabel {
    switch (status) {
      case 'pending': return 'Pending';
      case 'confirmed': return 'Confirmed';
      case 'preparing': return 'Preparing';
      case 'ready': return 'Ready';
      case 'picked_up': return 'Picked Up';
      case 'in_transit': return 'In Transit';
      case 'delivered': return 'Delivered';
      case 'cancelled': return 'Cancelled';
      default: return status;
    }
  }
}

/// Order item
class OrderItem {
  final String menuItemId;
  final String name;
  final String? imageUrl;
  final int quantity;
  final double price;
  final double totalPrice;
  final List<String> selectedOptions;
  final String? specialInstructions;

  OrderItem({
    required this.menuItemId,
    required this.name,
    this.imageUrl,
    required this.quantity,
    required this.price,
    required this.totalPrice,
    this.selectedOptions = const [],
    this.specialInstructions,
  });

  factory OrderItem.fromMap(Map<String, dynamic> data) {
    return OrderItem(
      menuItemId: data['menuItemId'] ?? '',
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'],
      quantity: data['quantity'] ?? 1,
      price: (data['price'] ?? 0.0).toDouble(),
      totalPrice: (data['totalPrice'] ?? 0.0).toDouble(),
      selectedOptions: List<String>.from(data['selectedOptions'] ?? []),
      specialInstructions: data['specialInstructions'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'menuItemId': menuItemId,
      'name': name,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'price': price,
      'totalPrice': totalPrice,
      'selectedOptions': selectedOptions,
      'specialInstructions': specialInstructions,
    };
  }
}