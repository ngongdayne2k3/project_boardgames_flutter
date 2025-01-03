import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/manufacturer.dart';
import '../config/app_config.dart';

class ManufacturerService {
  static const String _baseUrl = AppConfig.baseUrl;

  // Lấy tất cả nhà sản xuất
  static Future<List<Manufacturer>> getAllManufacturers() async {
    final response = await http.get(Uri.parse('$_baseUrl/manager/manufacturers'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Manufacturer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load manufacturers');
    }
  }

  // Tạo nhà sản xuất mới
  static Future<Manufacturer> createManufacturer(Manufacturer manufacturer) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/manager/manufacturers'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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
    final response = await http.put(
      Uri.parse('$_baseUrl/manager/manufacturers/${manufacturer.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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
    final response = await http.delete(Uri.parse('$_baseUrl/manager/manufacturers/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete manufacturer');
    }
  }
}