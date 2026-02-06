import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isAuthenticated = false;
  String? _role;

  bool get isAuthenticated => _isAuthenticated;
  String? get role => _role;

  /// Call on app startup
  Future<void> loadSession() async {
    _isAuthenticated = await _authService.isLoggedIn();
    if (_isAuthenticated) {
      _role = await _authService.getRole();
    }
    notifyListeners();
  }

  /// Login user
  Future<bool> login(String email, String password) async {
    final success = await _authService.login(email, password);

    if (success) {
      _isAuthenticated = true;
      _role = await _authService.getRole();
      notifyListeners();
      return true;
    }

    return false;
  }

  /// Logout user
  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    _role = null;
    notifyListeners();
  }
}
