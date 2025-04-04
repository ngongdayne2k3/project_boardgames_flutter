import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../../dto/login_dto.dart';  // Import LoginDTO
import '../admin/admin_dashboard_screen.dart';
import '../main_screen.dart';

class LoginScreen extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            // Tạo đối tượng LoginDTO từ dữ liệu nhập vào
            final loginDTO = LoginDTO(
              username: _usernameController.text.trim(),
              password: _passwordController.text.trim(),
            );

            // Gọi phương thức login của AuthService
            final user = await _authService.login(loginDTO);
            if (user != null) {
              final prefs = await SharedPreferences.getInstance();
              final userRole = prefs.getString('userRole');

              if (userRole == 'admin') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invalid username or password')),
              );
            }
          },
          child: Text('Login'),
        ),

            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}