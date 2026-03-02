import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Auth State Service - manages Firebase authentication state
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  User? _currentUser;
  bool _isLoading = true;
  
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  bool get isEmailVerified => _currentUser?.emailVerified ?? false;
  
  AuthService() {
    _init();
  }
  
  void _init() {
    _auth.authStateChanges().listen((user) {
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
    });
  }
  
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }
  
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Send verification email
      await credential.user?.sendEmailVerification();
      return credential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }
  
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  Future<void> reloadUser() async {
    await _currentUser?.reload();
    _currentUser = _auth.currentUser;
    notifyListeners();
  }
}
