import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/menu_item_model.dart';

/// Cart provider
class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  String? _restaurantId;
  String? _restaurantName;
  String? _restaurantPhotoUrl;
  double _deliveryFee = 0.0;
  double _tip = 0.0;
  double _donationAmount = 0.0;
  double _discount = 0.0;
  String? _couponCode;

  Map<String, CartItem> get items => _items;
  List<CartItem> get itemList => _items.values.toList();
  String? get restaurantId => _restaurantId;
  String? get restaurantName => _restaurantName;
  double get deliveryFee => _deliveryFee;
  double get tip => _tip;
  double get donationAmount => _donationAmount;
  double get discount => _discount;
  String? get couponCode => _couponCode;

  double get subtotal => itemList.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get total => (subtotal + _deliveryFee + _tip + _donationAmount - _discount).clamp(0.0, double.infinity);
  int get itemCount => itemList.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;

  /// Add item to cart
  void addItem(MenuItem menuItem, {int quantity = 1, List<String> options = const [], String? instructions}) {
    if (_restaurantId != null && _restaurantId != menuItem.restaurantId) {
      clearCart();
    }

    _restaurantId = menuItem.restaurantId;
    final key = '${menuItem.id}-${options.join(',')}';

    if (_items.containsKey(key)) {
      _items[key] = _items[key]!.copyWith(quantity: _items[key]!.quantity + quantity);
    } else {
      _items[key] = CartItem(
        menuItemId: menuItem.id,
        restaurantId: menuItem.restaurantId,
        name: menuItem.name,
        imageUrl: menuItem.imageUrl,
        price: menuItem.effectivePrice,
        quantity: quantity,
        selectedOptions: options,
        specialInstructions: instructions,
      );
    }
    notifyListeners();
  }

  /// Update item quantity
  void updateQuantity(String key, int quantity) {
    if (quantity <= 0) {
      _items.remove(key);
    } else {
      _items[key] = _items[key]!.copyWith(quantity: quantity);
    }
    if (_items.isEmpty) clearCart();
    notifyListeners();
  }

  /// Remove item
  void removeItem(String key) {
    _items.remove(key);
    if (_items.isEmpty) clearCart();
    notifyListeners();
  }

  /// Clear cart
  void clearCart() {
    _items.clear();
    _restaurantId = null;
    _restaurantName = null;
    _restaurantPhotoUrl = null;
    _deliveryFee = 0.0;
    _tip = 0.0;
    _donationAmount = 0.0;
    _discount = 0.0;
    _couponCode = null;
    notifyListeners();
  }

  /// Set delivery fee
  void setDeliveryFee(double fee) {
    _deliveryFee = fee;
    notifyListeners();
  }

  /// Set tip
  void setTip(double tip) {
    _tip = tip;
    notifyListeners();
  }

  /// Set donation
  void setDonation(double amount) {
    _donationAmount = amount;
    notifyListeners();
  }

  /// Apply coupon
  void applyCoupon(String code, double discountAmount) {
    _couponCode = code;
    _discount = discountAmount;
    notifyListeners();
  }

  /// Remove coupon
  void removeCoupon() {
    _couponCode = null;
    _discount = 0.0;
    notifyListeners();
  }

  /// Set restaurant info
  void setRestaurantInfo(String id, String name, String? photoUrl) {
    _restaurantId = id;
    _restaurantName = name;
    _restaurantPhotoUrl = photoUrl;
    notifyListeners();
  }
}