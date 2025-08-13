import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final String _baseUrl = "http://localhost:5000"; // change for production

  String? _accessToken;
  bool isLoading = false;
  bool get isAuthenticated => _accessToken != null;

  // REGISTER
  Future<void> register(String name, String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await http.post(
        Uri.parse("$_baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
        }),
      );

      if (res.statusCode == 201) {
        // auto-login after register
        await login(email, password);
      } else {
        throw Exception(jsonDecode(res.body)["message"]);
      }
    } catch (e) {
      debugPrint("Register error: $e");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // LOGIN
  Future<void> login(String email, String password,
      {bool rememberMe = false}) async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await http.post(
        Uri.parse("$_baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _accessToken = data["accessToken"];

        if (rememberMe) {
          await _storage.write(key: "accessToken", value: _accessToken);
        }

        notifyListeners();
      } else {
        throw Exception(jsonDecode(res.body)["message"]);
      }
    } catch (e) {
      debugPrint("Login error: $e");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // LOAD TOKEN FROM STORAGE (auto login)
  Future<void> loadStoredToken() async {
    _accessToken = await _storage.read(key: "accessToken");
    notifyListeners();
  }

  // LOGOUT
  Future<void> logout() async {
    try {
      if (_accessToken != null) {
        await http.post(
          Uri.parse("$_baseUrl/logout"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_accessToken",
          },
        );
      }
    } catch (e) {
      debugPrint("Logout request failed: $e");
    } finally {
      _accessToken = null;
      await _storage.delete(key: "accessToken");
      notifyListeners();
    }
  }

  // Helper for authorized requests
  Future<http.Response> authorizedGet(String endpoint) async {
    if (_accessToken == null) throw Exception("Not authenticated");
    return http.get(
      Uri.parse("$_baseUrl$endpoint"),
      headers: {
        "Authorization": "Bearer $_accessToken",
        "Content-Type": "application/json",
      },
    );
  }
}
