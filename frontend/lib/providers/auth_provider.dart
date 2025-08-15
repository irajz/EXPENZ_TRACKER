// auth_provider.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> initAuth() async {
    final token = await _authService.getAccessToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<bool> login(String email, String password,
      {required bool rememberMe}) async {
    _setLoading(true);
    try {
      final success = await _authService.login(email, password);
      _isAuthenticated = success;
      notifyListeners();
      return success;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    try {
      final success = await _authService.register(name, email, password);
      _isAuthenticated = success;
      notifyListeners();
      return success;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _isAuthenticated = false;
    } finally {
      _setLoading(false);
    }
  }
}
