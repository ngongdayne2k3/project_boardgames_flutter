import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/manufacturer.dart';

class ManufacturerService {
  static const String _baseUrl = AppConfig.baseUrl;

  // Lấy tất cả nhà sản xuất
  static Future<List<Manufacturer>> getAllManufacturers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/api/manufacturers'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Manufacturer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load manufacturers');
    }
  }

  // Tạo nhà sản xuất mới
  static Future<Manufacturer> createManufacturer(Manufacturer manufacturer) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$_baseUrl/api/manufacturers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(manufacturer.toJson()),
    );

    if (response.statusCode == 200) {
      return Manufacturer.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create manufacturer');
    }
  }

  // Cập nhật nhà sản xuất
  static Future<Manufacturer> updateManufacturer(Manufacturer manufacturer) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('$_baseUrl/api/manufacturers/${manufacturer.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(manufacturer.toJson()),
    );

    if (response.statusCode == 200) {
      return Manufacturer.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update manufacturer');
    }
  }

  // Xóa nhà sản xuất
  static Future<void> deleteManufacturer(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('$_baseUrl/api/manufacturers/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete manufacturer');
    }
  }
}