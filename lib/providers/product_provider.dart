import 'package:flutter/material.dart';
import 'package:project_boardgames_flutter/models/product.dart';
import 'package:project_boardgames_flutter/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await ProductService.getAllProducts();
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product, String token) async {
    try {
      final newProduct = await ProductService.addProduct(product, token);
      _products.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(Product product, String token) async {
    try {
      final updatedProduct = await ProductService.updateProduct(product, token);
      final index = _products.indexWhere((p) => p.id == updatedProduct.id);
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteProduct(int id, String token) async {
    try {
      await ProductService.deleteProduct(id, token);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}