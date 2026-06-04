import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';

/// Firebase service abstraction for MIWA
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Firebase instances
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;
  FirebaseStorage? _storage;
  FirebaseMessaging? _messaging;
  FirebaseAnalytics? _analytics;

  bool _initialized = false;

  /// Initialize Firebase
  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _storage = FirebaseStorage.instance;
      _messaging = FirebaseMessaging.instance;
      _analytics = FirebaseAnalytics.instance;

      // Enable offline persistence
      _firestore?.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      _initialized = true;
      debugPrint('Firebase initialized successfully');
    } catch (e) {
      debugPrint('Firebase initialization error: $e');
      rethrow;
    }
  }

  // Getters
  FirebaseAuth get auth {
    if (_auth == null) throw Exception('Firebase not initialized');
    return _auth!;
  }

  FirebaseFirestore get firestore {
    if (_firestore == null) throw Exception('Firebase not initialized');
    return _firestore!;
  }

  FirebaseStorage get storage {
    if (_storage == null) throw Exception('Firebase not initialized');
    return _storage!;
  }

  FirebaseMessaging get messaging {
    if (_messaging == null) throw Exception('Firebase not initialized');
    return _messaging!;
  }

  FirebaseAnalytics get analytics {
    if (_analytics == null) throw Exception('Firebase not initialized');
    return _analytics!;
  }

  bool get isInitialized => _initialized;

  // ===================== AUTHENTICATION =====================

  /// Email/Password sign up
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    return auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  /// Email/Password sign in
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Google sign in
  Future<UserCredential?> signInWithGoogle() async {
    // Implement with google_sign_in package
    try {
      final GoogleAuthProvider provider = GoogleAuthProvider();
      final userCredential = await auth.signInWithPopup(provider);
      return userCredential;
    } catch (e) {
      debugPrint('Google sign in error: $e');
      return null;
    }
  }

  /// Phone OTP sign in
  Future<void> signInWithPhone(String phone, void Function(PhoneAuthCredential) completion) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) async {
        await auth.signInWithCredential(credential);
        completion(credential);
      },
      verificationFailed: (e) {
        debugPrint('Phone verification failed: $e');
      },
      codeSent: (verificationId, forceResendingToken) {
        // OTP sent
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  /// Verify OTP
  Future<UserCredential?> verifyOTP(String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return await auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('OTP verification error: $e');
      return null;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await auth.signOut();
  }

  /// Get current user
  User? get currentUser => auth.currentUser;

  /// Stream auth state
  Stream<User?> get authStateChanges => auth.authStateChanges();

  // ===================== CLOUD FIRESTORE =====================

  /// Get collection reference
  CollectionReference collection(String path) {
    return firestore.collection(path);
  }

  /// Document reference
  DocumentReference document(String path) {
    return firestore.doc(path);
  }

  /// Create document with auto-generated ID
  Future<DocumentReference> addDocument(String collectionPath, Map<String, dynamic> data) async {
    return firestore.collection(collectionPath).add(data);
  }

  /// Create document with specific ID
  Future<void> setDocument(String collectionPath, String docId, Map<String, dynamic> data) async {
    await firestore.collection(collectionPath).doc(docId).set(data);
  }

  /// Update document
  Future<void> updateDocument(String collectionPath, String docId, Map<String, dynamic> data) async {
    await firestore.collection(collectionPath).doc(docId).update(data);
  }

  /// Delete document
  Future<void> deleteDocument(String collectionPath, String docId) async {
    await firestore.collection(collectionPath).doc(docId).delete();
  }

  /// Get document
  Future<DocumentSnapshot> getDocument(String collectionPath, String docId) async {
    return firestore.collection(collectionPath).doc(docId).get();
  }

  /// Query collection
  Future<QuerySnapshot> queryCollection(
    String collectionPath, {
    String? field,
    dynamic isEqualTo,
    dynamic isGreaterThan,
    dynamic isLessThan,
    String? orderBy,
    bool descending = false,
    int? limit,
    List<WhereFilter>? filters,
  }) async {
    Query query = firestore.collection(collectionPath);

    if (field != null && isEqualTo != null) {
      query = query.where(field, isEqualTo: isEqualTo);
    }
    if (field != null && isGreaterThan != null) {
      query = query.where(field, isGreaterThan: isGreaterThan);
    }
    if (field != null && isLessThan != null) {
      query = query.where(field, isLessThan: isLessThan);
    }
    if (filters != null) {
      for (final filter in filters) {
        query = query.where(filter.field, isEqualTo: filter.value);
      }
    }
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.get();
  }

  /// Real-time document stream
  Stream<DocumentSnapshot> streamDocument(String collectionPath, String docId) {
    return firestore.collection(collectionPath).doc(docId).snapshots();
  }

  /// Real-time collection stream
  Stream<QuerySnapshot> streamCollection(
    String collectionPath, {
    String? field,
    dynamic isEqualTo,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query query = firestore.collection(collectionPath);
    if (field != null && isEqualTo != null) {
      query = query.where(field, isEqualTo: isEqualTo);
    }
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots();
  }

  /// Run transaction
  Future<T> runTransaction<T>(Future<T> Function(Transaction transaction) handler) async {
    return firestore.runTransaction(handler);
  }

  // ===================== FIREBASE STORAGE =====================

  /// Upload file
  Future<String> uploadFile(String path, String fileName, Uint8List bytes) async {
    final ref = storage.ref().child('$path/$fileName');
    final uploadTask = ref.putData(bytes);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  /// Get download URL
  Future<String> getDownloadURL(String path) async {
    return storage.ref(path).getDownloadURL();
  }

  /// Delete file
  Future<void> deleteFile(String path) async {
    await storage.ref(path).delete();
  }

  // ===================== CLOUD MESSAGING =====================

  /// Request notification permissions
  Future<NotificationSettings> requestNotificationPermission() async {
    return messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  /// Get FCM token
  Future<String?> getFCMToken() async {
    try {
      return await messaging.getToken();
    } catch (e) {
      debugPrint('FCM token error: $e');
      return null;
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await messaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await messaging.unsubscribeFromTopic(topic);
  }

  /// Stream foreground messages
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  /// Handle background messages
  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    debugPrint('Background message: ${message.messageId}');
  }

  // ===================== ANALYTICS =====================

  /// Log event
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    final Map<String, Object>? castedParameters = parameters != null
        ? Map<String, Object>.from(parameters)
        : null;
    await analytics.logEvent(name: name, parameters: castedParameters);
  }

  /// Set user properties
  Future<void> setUserProperties(String userId, {Map<String, String>? properties}) async {
    await analytics.setUserId(id: userId);
  }
}

/// Helper class for complex where filters
class WhereFilter {
  final String field;
  final dynamic value;
  WhereFilter({required this.field, required this.value});
}