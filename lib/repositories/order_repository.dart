import '../core/constants.dart';
import '../models/order_model.dart';
import '../services/firebase_service.dart';

/// Order repository
class OrderRepository {
  final FirebaseService _firebase = FirebaseService();

  /// Create order
  Future<String?> createOrder(Order order) async {
    try {
      final docRef = await _firebase.addDocument(AppConstants.ordersCollection, order.toMap());
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  /// Get orders for a user
  Future<List<Order>> getUserOrders(String userId) async {
    try {
      final snapshot = await _firebase.queryCollection(
        AppConstants.ordersCollection,
        field: 'userId',
        isEqualTo: userId,
        orderBy: 'createdAt',
        descending: true,
      );
      return snapshot.docs.map((doc) =>
          Order.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Stream user orders
  Stream<List<Order>> streamUserOrders(String userId) {
    return _firebase.streamCollection(
      AppConstants.ordersCollection,
      field: 'userId',
      isEqualTo: userId,
      orderBy: 'createdAt',
      descending: true,
    ).map((snapshot) {
      return snapshot.docs.map((doc) =>
          Order.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  /// Get restaurant orders
  Future<List<Order>> getRestaurantOrders(String restaurantId) async {
    try {
      final snapshot = await _firebase.queryCollection(
        AppConstants.ordersCollection,
        field: 'restaurantId',
        isEqualTo: restaurantId,
        orderBy: 'createdAt',
        descending: true,
      );
      return snapshot.docs.map((doc) =>
          Order.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Stream restaurant orders
  Stream<List<Order>> streamRestaurantOrders(String restaurantId) {
    return _firebase.streamCollection(
      AppConstants.ordersCollection,
      field: 'restaurantId',
      isEqualTo: restaurantId,
      orderBy: 'createdAt',
      descending: true,
    ).map((snapshot) {
      return snapshot.docs.map((doc) =>
          Order.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  /// Get rider deliveries
  Future<List<Order>> getRiderOrders(String riderId) async {
    try {
      final snapshot = await _firebase.queryCollection(
        AppConstants.ordersCollection,
        field: 'riderId',
        isEqualTo: riderId,
        orderBy: 'createdAt',
        descending: true,
      );
      return snapshot.docs.map((doc) =>
          Order.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Stream rider orders
  Stream<List<Order>> streamRiderOrders(String riderId) {
    return _firebase.streamCollection(
      AppConstants.ordersCollection,
      field: 'riderId',
      isEqualTo: riderId,
    ).map((snapshot) {
      return snapshot.docs.map((doc) =>
          Order.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  /// Stream available deliveries for riders
  Stream<List<Order>> streamAvailableDeliveries() {
    return _firebase.streamCollection(
      AppConstants.ordersCollection,
      field: 'status',
      isEqualTo: 'ready',
    ).map((snapshot) {
      return snapshot.docs.map((doc) =>
          Order.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firebase.updateDocument(AppConstants.ordersCollection, orderId, {
      'status': status,
      'updatedAt': DateTime.now(),
    });
  }

  /// Assign rider to order
  Future<void> assignRider(String orderId, String riderId) async {
    await _firebase.updateDocument(AppConstants.ordersCollection, orderId, {
      'riderId': riderId,
      'status': 'picked_up',
      'updatedAt': DateTime.now(),
    });
  }

  /// Get order by ID
  Future<Order?> getOrderById(String orderId) async {
    try {
      final doc = await _firebase.getDocument(AppConstants.ordersCollection, orderId);
      if (doc.exists) {
        return Order.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Stream order
  Stream<Order?> streamOrder(String orderId) {
    return _firebase.streamDocument(AppConstants.ordersCollection, orderId).map((doc) {
      if (doc.exists) {
        return Order.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    });
  }
}