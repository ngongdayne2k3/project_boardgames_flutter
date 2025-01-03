import 'role.dart';
import 'order.dart';

class User {
  final int? id;
  final String name;
  final String username;
  final String password;
  final String email;
  final String phoneNumber;
  final String address;
  final String? profileImageUrl;
  final Role role;
  final List<Order> orders;

  User({this.id, required this.name, required this.username, required this.password, required this.email, required this.phoneNumber, required this.address, this.profileImageUrl, required this.role, required this.orders});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      profileImageUrl: json['profileImageUrl'],
      role: Role.values.firstWhere((e) => e.toString() == 'Role.${json['role']}'),
      orders: (json['orders'] as List).map((order) => Order.fromJson(order)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'profileImageUrl': profileImageUrl,
      'role': role.toString().split('.').last,
      'orders': orders.map((order) => order.toJson()).toList(),
    };
  }
}