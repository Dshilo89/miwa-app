import '../core/constants.dart';
import '../models/restaurant_model.dart';
import '../models/menu_item_model.dart';
import '../services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Restaurant repository
class RestaurantRepository {
  final FirebaseService _firebase = FirebaseService();

  /// Get restaurants
  Future<List<Restaurant>> getRestaurants({String? categoryId, bool? isOpen}) async {
    try {
      Query query = _firebase.firestore.collection(AppConstants.restaurantsCollection)
          .where('isActive', isEqualTo: true);

      if (isOpen != null) {
        query = query.where('isOpen', isEqualTo: isOpen);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) =>
          Restaurant.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Stream restaurants
  Stream<List<Restaurant>> streamRestaurants() {
    return _firebase.streamCollection(
      AppConstants.restaurantsCollection,
      field: 'isActive',
      isEqualTo: true,
      orderBy: 'rating',
      descending: true,
    ).map((snapshot) {
      return snapshot.docs.map((doc) =>
          Restaurant.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  /// Get restaurant by ID
  Future<Restaurant?> getRestaurantById(String id) async {
    try {
      final doc = await _firebase.getDocument(AppConstants.restaurantsCollection, id);
      if (doc.exists) {
        return Restaurant.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get menu items for a restaurant
  Future<List<MenuItem>> getMenuItems(String restaurantId) async {
    try {
      final snapshot = await _firebase.queryCollection(
        AppConstants.menusCollection,
        field: 'restaurantId',
        isEqualTo: restaurantId,
      );
      return snapshot.docs.map((doc) =>
          MenuItem.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Stream menu items
  Stream<List<MenuItem>> streamMenuItems(String restaurantId) {
    return _firebase.streamCollection(
      AppConstants.menusCollection,
      field: 'restaurantId',
      isEqualTo: restaurantId,
    ).map((snapshot) {
      return snapshot.docs.map((doc) =>
          MenuItem.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  /// Search restaurants
  Future<List<Restaurant>> searchRestaurants(String query) async {
    try {
      final snapshot = await _firebase.firestore.collection(AppConstants.restaurantsCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .startAt([query])
          .endAt([query + '\uf8ff'])
          .get();
      return snapshot.docs.map((doc) =>
          Restaurant.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Update restaurant
  Future<void> updateRestaurant(String id, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now();
    await _firebase.updateDocument(AppConstants.restaurantsCollection, id, data);
  }
}