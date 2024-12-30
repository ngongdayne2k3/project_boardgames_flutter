import 'order.dart';
import 'role.dart';

class User {
  int? id;
  String? name;
  String? username;
  String? password;
  String? email;
  String? phoneNumber;
  String? address;
  Role? role;
  List<Order>? orders;

  User({this.id, this.name, this.username, this.password, this.email, this.phoneNumber, this.address, this.role, this.orders});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      role: Role.values.firstWhere((e) => e.toString() == 'Role.${json['role']}'),
      orders: (json['orders'] as List).map((i) => Order.fromJson(i)).toList(),
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
      'role': role?.toString().split('.').last,
      'orders': orders?.map((i) => i.toJson()).toList(),
    };
  }
}