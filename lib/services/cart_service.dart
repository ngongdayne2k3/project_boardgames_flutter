import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.dart';
import '../models/cart_item.dart';
import '../config/app_config.dart';

class CartService {
  static const String _baseUrl = AppConfig.baseUrl;

  // Lấy giỏ hàng của người dùng
  static Future<Cart> getCart(String username) async {
    final response = await http.get(Uri.parse('$_baseUrl/customer/cart?username=$username'));

    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load cart');
    }
  }

  // Thêm sản phẩm vào giỏ hàng
  static Future<Cart> addToCart(String username, int productId, int quantity) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/customer/add?productId=$productId&quantity=$quantity'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'username': username}),
    );

    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add to cart');
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  static Future<void> removeFromCart(String username, int cartItemId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/customer/remove/$cartItemId?username=$username'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove from cart');
    }
  }
}