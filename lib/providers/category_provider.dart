import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  // Lấy tất cả danh mục
  Future<void> fetchAllCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await CategoryService.getAllCategories();
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tạo danh mục mới
  Future<void> addCategory(Category category) async {
    _isLoading = true;
    notifyListeners();

    try {
      Category newCategory = await CategoryService.createCategory(category);
      _categories.add(newCategory);
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cập nhật danh mục
  Future<void> updateCategory(Category category) async {
    _isLoading = true;
    notifyListeners();

    try {
      Category updatedCategory = await CategoryService.updateCategory(category);
      int index = _categories.indexWhere((c) => c.id == updatedCategory.id);
      if (index != -1) {
        _categories[index] = updatedCategory;
      }
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Xóa danh mục
  Future<void> deleteCategory(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await CategoryService.deleteCategory(id);
      _categories.removeWhere((c) => c.id == id);
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}