// constants.dart
const String apiBaseUrl = "http://192.168.8.115:5000/api/auth";

// Endpoints
class ApiEndpoints {
  static const login = "$apiBaseUrl/login";
  static const register = "$apiBaseUrl/register";
  static const logout = "$apiBaseUrl/logout";
  static const refreshToken = "$apiBaseUrl/refresh";
}
