import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../config/app_config.dart';

class CategoryService {
  static const String _baseUrl = AppConfig.baseUrl;

  // Lấy tất cả danh mục
  static Future<List<Category>> getAllCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/manager/categories'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Tạo danh mục mới
  static Future<Category> createCategory(Category category) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/manager/categories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(category.toJson()),
    );

    if (response.statusCode == 200) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create category');
    }
  }

  // Cập nhật danh mục
  static Future<Category> updateCategory(Category category) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/manager/categories/${category.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(category.toJson()),
    );

    if (response.statusCode == 200) {
      return Category.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update category');
    }
  }

  // Xóa danh mục
  static Future<void> deleteCategory(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/manager/categories/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }
}
