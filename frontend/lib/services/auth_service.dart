import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl =
      'http://10.0.2.2:5000/api/auth'; // Localhost for emulator
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Login
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'access_token', value: data['accessToken']);
      await _storage.write(key: 'refresh_token', value: data['refreshToken']);
      return true;
    }
    return false;
  }

  // Logout
  Future<void> logout() async {
    final refreshToken = await _storage.read(key: 'refresh_token');
    await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );
    await _storage.deleteAll();
  }

  // Get protected data
  Future<http.Response> getProtected(String endpoint) async {
    String? token = await _storage.read(key: 'access_token');
    final res = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 401) {
      // Access token expired, refresh it
      final refreshed = await refreshAccessToken();
      if (refreshed) {
        token = await _storage.read(key: 'access_token');
        return http.get(
          Uri.parse('$baseUrl/$endpoint'),
          headers: {'Authorization': 'Bearer $token'},
        );
      }
    }
    return res;
  }

  // Refresh token
  Future<bool> refreshAccessToken() async {
    final refreshToken = await _storage.read(key: 'refresh_token');
    final response = await http.post(
      Uri.parse('$baseUrl/refresh-token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'access_token', value: data['accessToken']);
      return true;
    }
    return false;
  }
}
