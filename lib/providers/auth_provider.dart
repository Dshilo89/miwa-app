import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../core/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Authentication provider
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _initialized = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;
  bool get isInitialized => _initialized;
  String? get userId => _authRepo.currentUserId;
  String get userRole => _user?.role ?? 'customer';

  /// Initialize auth provider
  Future<void> initialize() async {
    _authRepo.authState.listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        _user = await _authRepo.getUserById(firebaseUser.uid);
      } else {
        _user = null;
      }
      _initialized = true;
      notifyListeners();
    });
  }

  /// Sign up
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    String role = 'customer',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authRepo.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        role: role,
      );
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign in
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authRepo.signIn(email, password);
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign in anonymously / Continue as Guest
  Future<bool> signInAnonymously() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authRepo.signInAnonymously();
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authRepo.signInWithGoogle();
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _authRepo.signOut();
    _user = null;
    notifyListeners();
  }

  /// Update profile
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (_user == null) return;
    await _authRepo.updateProfile(_user!.id, updates);
    _user = await _authRepo.getUserById(_user!.id);
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Check if user has a specific role
  bool hasRole(String role) => _user?.role == role;
  bool get isCustomer => hasRole(AppConstants.roleCustomer);
  bool get isRider => hasRole(AppConstants.roleRider);
  bool get isRestaurant => hasRole(AppConstants.roleRestaurant);
  bool get isAdmin => hasRole(AppConstants.roleAdmin);
}