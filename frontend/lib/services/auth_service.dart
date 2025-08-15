// auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/constants.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Save tokens
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  // Read tokens
  Future<String?> getAccessToken() => _storage.read(key: 'access_token');
  Future<String?> getRefreshToken() => _storage.read(key: 'refresh_token');

  // Clear tokens
  Future<void> clearTokens() async => await _storage.deleteAll();

  // Login
  Future<bool> login(String email, String password) async {
    final res = await http.post(
      Uri.parse(ApiEndpoints.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      await _saveTokens(data['accessToken'], data['refreshToken']);
      return true;
    }
    return false;
  }

  // Register
  Future<bool> register(String name, String email, String password) async {
    final res = await http.post(
      Uri.parse(ApiEndpoints.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (res.statusCode == 201) {
      return await login(email, password);
    }
    return false;
  }

  // Logout
  Future<void> logout() async {
    final refreshToken = await getRefreshToken();
    await http.post(
      Uri.parse(ApiEndpoints.logout),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );
    await clearTokens();
  }

  // Refresh Access Token
  Future<bool> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    final res = await http.post(
      Uri.parse(ApiEndpoints.refreshToken),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      await _storage.write(key: 'access_token', value: data['accessToken']);
      return true;
    }
    return false;
  }

  // Authorized GET with auto-refresh
  Future<http.Response> authorizedGet(String endpoint) async {
    String? token = await getAccessToken();
    var res = await http.get(
      Uri.parse(endpoint),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 401) {
      final refreshed = await refreshAccessToken();
      if (refreshed) {
        token = await getAccessToken();
        res = await http.get(
          Uri.parse(endpoint),
          headers: {'Authorization': 'Bearer $token'},
        );
      }
    }
    return res;
  }
}
