import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';

class CartProvider with ChangeNotifier {
  Cart? _cart;
  bool _isLoading = false;

  Cart? get cart => _cart;
  bool get isLoading => _isLoading;

  // Lấy giỏ hàng
  Future<void> fetchCart(String username) async {
    _isLoading = true;
    notifyListeners();

    try {
      _cart = await CartService.getCart(username);
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm sản phẩm vào giỏ hàng
  Future<void> addToCart(String username, int productId, int quantity) async {
    _isLoading = true;
    notifyListeners();

    try {
      _cart = await CartService.addToCart(username, productId, quantity);
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  Future<void> removeFromCart(String username, int cartItemId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await CartService.removeFromCart(username, cartItemId);
      _cart?.items.removeWhere((item) => item.id == cartItemId);
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}