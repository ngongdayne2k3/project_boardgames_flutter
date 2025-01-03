import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_boardgames_flutter/models/order.dart';
import 'package:project_boardgames_flutter/config/app_config.dart';

class OrderService {
  static const String _baseUrl = AppConfig.baseUrl;

  // Lấy tất cả đơn hàng
  static Future<List<Order>> getAllOrders(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/orders'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  // Tạo đơn hàng
  static Future<Order> createOrder(Order order, String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(order.toJson()),
    );

    if (response.statusCode == 200) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create order');
    }
  }

  // Cập nhật trạng thái đơn hàng
  static Future<Order> updateOrderStatus(int orderId, String status, String token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/api/orders/$orderId/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update order status');
    }
  }
}