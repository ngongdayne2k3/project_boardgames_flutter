import 'package:flutter/material.dart';
import 'package:project_boardgames_flutter/models/user.dart';
import 'package:project_boardgames_flutter/services/user_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;

  Future<bool> login(String username, String password) async {
    try {
      _token = await UserService.login(username, password);
      _user = await UserService.getUserProfile(_token!);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> register(User user) async {
    try {
      _user = await UserService.register(user);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  // Cập nhật thông tin người dùng
  Future<void> updateUserProfile(User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await UserService.updateUser(user, _token!);
      notifyListeners();
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    _token = null;
    notifyListeners();
  }
}