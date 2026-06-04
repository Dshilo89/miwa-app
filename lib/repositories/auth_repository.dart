import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';
import '../utils/app_utils.dart';

/// Authentication repository
class AuthRepository {
  final FirebaseService _firebase = FirebaseService();

  /// Sign up with email/password
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    String role = 'customer',
  }) async {
    try {
      final userCredential = await _firebase.signUpWithEmail(email, password);
      final user = userCredential.user;
      if (user == null) return null;

      final userModel = UserModel(
        id: user.uid,
        email: email,
        phone: phone,
        fullName: fullName,
        role: role,
        referralCode: AppUtils.generateReferralCode(fullName),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firebase.setDocument(
        AppConstants.usersCollection,
        user.uid,
        userModel.toMap(),
      );

      // Create wallet
      await _firebase.setDocument(
        AppConstants.walletsCollection,
        user.uid,
        {
          'userId': user.uid,
          'balance': 0.0,
          'pendingBalance': 0.0,
          'loyaltyPoints': 0,
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
        },
      );

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Sign in with email/password
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final userCredential = await _firebase.signInWithEmail(email, password);
      final user = userCredential.user;
      if (user == null) return null;

      return await getUserById(user.uid);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      final userCredential = await _firebase.signInWithGoogle();
      if (userCredential == null) return null;
      final user = userCredential.user;
      if (user == null) return null;

      // Check if user exists
      final existingUser = await getUserById(user.uid);
      if (existingUser != null) return existingUser;

      // Create new user
      final userModel = UserModel(
        id: user.uid,
        email: user.email ?? '',
        phone: user.phoneNumber ?? '',
        fullName: user.displayName ?? 'User',
        photoUrl: user.photoURL,
        role: 'customer',
        referralCode: AppUtils.generateReferralCode(user.displayName ?? 'User'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firebase.setDocument(AppConstants.usersCollection, user.uid, userModel.toMap());
      return userModel;
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  /// Sign in with phone OTP
  Future<void> signInWithPhone(String phone, void Function(PhoneAuthCredential) callback) async {
    try {
      await _firebase.signInWithPhone(phone, callback);
    } catch (e) {
      throw Exception('Phone sign in failed: $e');
    }
  }

  /// Verify OTP
  Future<UserModel?> verifyOTP(String verificationId, String smsCode) async {
    final userCredential = await _firebase.verifyOTP(verificationId, smsCode);
    if (userCredential == null) return null;
    final user = userCredential.user;
    if (user == null) return null;

    return await getUserById(user.uid);
  }

  /// Sign out
  Future<void> signOut() async {
    await _firebase.signOut();
  }

  /// Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firebase.getDocument(AppConstants.usersCollection, userId);
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Stream user
  Stream<UserModel?> streamUser(String userId) {
    return _firebase.streamDocument(AppConstants.usersCollection, userId).map((doc) {
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    });
  }

  /// Update user profile
  Future<void> updateProfile(String userId, Map<String, dynamic> updates) async {
    updates['updatedAt'] = DateTime.now();
    await _firebase.updateDocument(AppConstants.usersCollection, userId, updates);
  }

  /// Get current auth user
  bool get isLoggedIn => _firebase.currentUser != null;
  String? get currentUserId => _firebase.currentUser?.uid;

  /// Auth state stream
  Stream<User?> get authState => _firebase.authStateChanges;

  /// Handle Firebase auth errors
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found': return 'No user found with this email';
      case 'wrong-password': return 'Wrong password provided';
      case 'email-already-in-use': return 'Email already registered';
      case 'invalid-email': return 'Invalid email address';
      case 'weak-password': return 'Password should be at least 6 characters';
      case 'user-disabled': return 'This account has been disabled';
      case 'too-many-requests': return 'Too many attempts. Please try again later';
      case 'operation-not-allowed': return 'This sign in method is not enabled';
      case 'invalid-credential': return 'Invalid credentials provided';
      default: return 'Authentication failed: ${e.message}';
    }
  }
}