import 'package:flutter/material.dart';
import 'package:project_boardgames_flutter/models/order.dart';
import 'package:project_boardgames_flutter/services/order_service.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await OrderService.getAllOrders(token);
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createOrder(Order order, String token) async {
    try {
      final newOrder = await OrderService.createOrder(order, token);
      _orders.add(newOrder);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateOrderStatus(int orderId, String status, String token) async {
    try {
      final updatedOrder = await OrderService.updateOrderStatus(orderId, status, token);
      final index = _orders.indexWhere((o) => o.id == updatedOrder.id);
      if (index != -1) {
        _orders[index] = updatedOrder;
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }
}