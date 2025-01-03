import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_boardgames_flutter/models/user.dart';
import 'package:project_boardgames_flutter/config/app_config.dart';

class UserService {
  static const String _baseUrl = AppConfig.baseUrl;

  // Đăng nhập
  static Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return response.body; // Trả về JWT token
    } else {
      throw Exception('Failed to login');
    }
  }

  // Lấy thông tin người dùng
  static Future<User> getUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/users/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  // Đăng ký người dùng
  static Future<User> register(User user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register user');
    }
  }

  // Cập nhật thông tin người dùng
  static Future<User> updateUser(User user, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/api/users/${user.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }
}