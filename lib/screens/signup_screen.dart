import 'package:flutter/material.dart';
import '../models/user_role.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';  // Import LoginScreen

class SignupScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();  // Thêm controller cho username
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();  // Thêm controller cho số điện thoại
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Trường nhập tên
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            // Trường nhập username
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            // Trường nhập email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            // Trường nhập số điện thoại
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            // Trường nhập mật khẩu
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            // Nút đăng ký
            ElevatedButton(
              onPressed: () async {
                // Lấy dữ liệu từ các trường nhập
                final name = _nameController.text.trim();
                final username = _usernameController.text.trim();
                final email = _emailController.text.trim();
                final phoneNumber = _phoneNumberController.text.trim();
                final password = _passwordController.text.trim();

                try {
                  // Gọi phương thức signup từ AuthService
                  final success = await _authService.signup(
                    name: name,
                    username: username,
                    email: email.isNotEmpty ? email : null,
                    phoneNumber: phoneNumber.isNotEmpty ? phoneNumber : null,
                    password: password,
                    role: UserRole.customer,  // Mặc định là customer
                  );

                  if (success) {
                    // Đăng ký thành công, chuyển đến màn hình đăng nhập
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  } else {
                    // Hiển thị thông báo lỗi nếu email hoặc số điện thoại đã tồn tại
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Email or phone number already exists')),
                    );
                  }
                } catch (e) {
                  // Xử lý các lỗi khác (ví dụ: email và số điện thoại đều trống)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: Text('Sign Up'),
            ),
            // Nút chuyển đến màn hình đăng nhập
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}