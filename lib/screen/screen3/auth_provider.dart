import 'package:flutter/material.dart';
import 'package:project_boardgames_flutter/models/user.dart';
import 'package:project_boardgames_flutter/models/order.dart';
import 'package:project_boardgames_flutter/models/role.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  final List<User> _users = []; // Danh sách người dùng (bao gồm cả khách hàng)

  User? get user => _user;
  List<User> get users => _users;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  void updateUser(User updatedUser) {
    final index = _users.indexWhere((u) => u.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
      notifyListeners();
    }
  }

  void deleteUser(int userId) {
    _users.removeWhere((u) => u.id == userId);
    notifyListeners();
  }

  void updateOrderStatus(int orderId, String status, {String? reason}) {
    for (var user in _users) {
      final order = user.orders?.firstWhere(
            (o) => o.id == orderId,
        orElse: () => Order(),
      );
      if (order !=null && order.id != null) {
        order.status = status;
        order.reason = reason;
        notifyListeners();
        break;
      }
    }
  }

  bool login(String username, String password) {
    final user = _users.firstWhere(
          (u) => u.username == username && u.password == password,
      orElse: () => User(),
    );

    if (user.id != null) {
      _user = user;
      notifyListeners();
      return true;
    }
    return false;
  }
}