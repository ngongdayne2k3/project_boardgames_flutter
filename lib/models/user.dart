import 'user_role.dart';

class User {
  String id;
  String name;
  String username; // Thêm thuộc tính username
  String? email;
  String? phoneNumber;
  String? address;
  String? avatarUrl;
  UserRole role;
  String password; // Thêm thuộc tính password

  User({
    required this.id,
    required this.name,
    required this.username, // Thêm username vào constructor
    this.email,
    this.phoneNumber,
    this.address,
    this.avatarUrl,
    required this.role,
    required this.password, // Thêm password vào constructor
  });

  // Kiểm tra hợp lệ: email hoặc phoneNumber phải có ít nhất một giá trị
  bool isValid() {
    return email != null || phoneNumber != null;
  }

  // Chuyển đổi User thành Map để lưu vào SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username, // Thêm username vào Map
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'avatarUrl': avatarUrl,
      'role': role == UserRole.admin ? 'admin' : 'customer',
      'password': password, // Thêm password vào Map
    };
  }

  // Chuyển đổi từ Map thành User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      username: map['username'], // Thêm username từ Map
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      avatarUrl: map['avatarUrl'],
      role: map['role'] == 'admin' ? UserRole.admin : UserRole.customer,
      password: map['password'], // Thêm password từ Map
    );
  }
}