import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../models/menu_item_model.dart';
import '../repositories/restaurant_repository.dart';

/// Restaurant provider
class RestaurantProvider extends ChangeNotifier {
  final RestaurantRepository _repo = RestaurantRepository();

  List<Restaurant> _restaurants = [];
  List<MenuItem> _menuItems = [];
  Restaurant? _selectedRestaurant;
  bool _isLoading = false;
  String? _error;

  List<Restaurant> get restaurants => _restaurants;
  List<MenuItem> get menuItems => _menuItems;
  Restaurant? get selectedRestaurant => _selectedRestaurant;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load restaurants
  Future<void> loadRestaurants() async {
    _isLoading = true;
    notifyListeners();
    _restaurants = await _repo.getRestaurants();
    _isLoading = false;
    notifyListeners();
  }

  /// Load menu items
  Future<void> loadMenuItems(String restaurantId) async {
    _isLoading = true;
    notifyListeners();
    _menuItems = await _repo.getMenuItems(restaurantId);
    _isLoading = false;
    notifyListeners();
  }

  /// Select restaurant
  void selectRestaurant(Restaurant restaurant) {
    _selectedRestaurant = restaurant;
    notifyListeners();
  }

  /// Search restaurants
  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) {
      await loadRestaurants();
      return;
    }
    _isLoading = true;
    notifyListeners();
    _restaurants = await _repo.searchRestaurants(query);
    _isLoading = false;
    notifyListeners();
  }
}