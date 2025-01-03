import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_boardgames_flutter/models/product.dart';
import 'package:project_boardgames_flutter/config/app_config.dart';

class ProductService {
  static const String _baseUrl = AppConfig.baseUrl;

  // Lấy tất cả sản phẩm
  static Future<List<Product>> getAllProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/products'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Thêm sản phẩm
  static Future<Product> addProduct(Product product, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/products'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add product');
    }
  }

  // Cập nhật sản phẩm
  static Future<Product> updateProduct(Product product, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/api/products/${product.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update product');
    }
  }

  // Xóa sản phẩm
  static Future<void> deleteProduct(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/api/products/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}