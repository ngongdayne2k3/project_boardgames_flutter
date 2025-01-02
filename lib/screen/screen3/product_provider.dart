import 'dart:io';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _products = [];

  List<Map<String, dynamic>> get products => _products;

  void addProduct(Map<String, dynamic> product) {
    _products.add(product);
    notifyListeners();
  }

  void editProduct(int index, Map<String, dynamic> product) {
    _products[index] = product;
    notifyListeners();
  }

  void deleteProduct(int index) {
    _products.removeAt(index);
    notifyListeners();
  }
}