import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_boardgames_flutter/screens/auth/login_screen.dart'; // Import màn hình đăng nhập

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple, // Màu nền AppBar
        elevation: 10, // Đổ bóng AppBar
        actions: [
          // Nút đăng xuất
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              // Xóa trạng thái đăng nhập
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              await prefs.remove('userId');
              await prefs.remove('userRole');

              // Chuyển hướng về màn hình đăng nhập
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );

              // Hiển thị thông báo đăng xuất thành công
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đăng xuất thành công!')),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade100,
              Colors.deepPurple.shade50,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome, Admin!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 40),
              _buildDashboardButton(
                context,
                icon: Icons.manage_search,
                label: 'Manage Products',
                color: Colors.blue,
                onPressed: () {
                  Navigator.pushNamed(context, '/manage-products');
                },
              ),
              SizedBox(height: 20),
              _buildDashboardButton(
                context,
                icon: Icons.list_alt,
                label: 'Manage Orders',
                color: Colors.green,
                onPressed: () {
                  Navigator.pushNamed(context, '/manage-orders');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm tạo nút dashboard
  Widget _buildDashboardButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onPressed,
      }) {
    return Card(
      elevation: 5, // Đổ bóng
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Bo góc
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        splashColor: color.withOpacity(0.3), // Hiệu ứng khi nhấn
        child: Container(
          width: 200,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(0.4),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}