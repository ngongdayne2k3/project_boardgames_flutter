import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  // Đăng ký người dùng
  Future<void> register(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await UserService.register(user);
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Đăng nhập
  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      String token = await UserService.login(username, password);
      // Lưu token hoặc thực hiện các hành động khác sau khi đăng nhập
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Lấy thông tin người dùng
  Future<void> fetchUserProfile(String username) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await UserService.getUserProfile(username);
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}