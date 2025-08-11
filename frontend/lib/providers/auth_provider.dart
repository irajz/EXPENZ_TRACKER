import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isAuthenticated = false;

  Future<void> register(String name, String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      // TODO: Call your backend register API
      await Future.delayed(const Duration(seconds: 2)); // mock delay
      isAuthenticated = true;
    } catch (e) {
      debugPrint('Register error: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      // TODO: Call your backend login API
      await Future.delayed(const Duration(seconds: 2)); // mock delay
      isAuthenticated = true;
    } catch (e) {
      debugPrint('Login error: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  void logout() {
    isAuthenticated = false;
    notifyListeners();
  }
}
