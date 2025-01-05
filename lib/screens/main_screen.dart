import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_boardgames_flutter/screens/login_screen.dart';
import 'package:project_boardgames_flutter/screens/product_list_screen.dart';
import 'package:project_boardgames_flutter/screens/cart_screen.dart';
// import 'package:project_boardgames_flutter/screens/customer_orders_screen.dart';
// import 'package:project_boardgames_flutter/screens/edit_customer_screen.dart';
import 'package:project_boardgames_flutter/models/cart.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isLoggedIn = false;
  final Cart _cart = Cart(); // Giỏ hàng

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Kiểm tra trạng thái đăng nhập khi khởi tạo
  }

  // Hàm kiểm tra trạng thái đăng nhập
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // Lấy trạng thái đăng nhập

    if (!isLoggedIn) {
      // Nếu chưa đăng nhập, chuyển hướng đến LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      // Nếu đã đăng nhập, cập nhật trạng thái
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      // Hiển thị màn hình loading nếu chưa đăng nhập
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Hiển thị loading
        ),
      );
    }

    // Nếu đã đăng nhập, hiển thị giao diện chính
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trang chính',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple, // Màu nền AppBar
        elevation: 10.0, // Đổ bóng AppBar
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
        child: GridView.count(
          crossAxisCount: 2, // Số cột trong lưới
          padding: EdgeInsets.all(20.0), // Khoảng cách xung quanh lưới
          crossAxisSpacing: 15.0, // Khoảng cách giữa các cột
          mainAxisSpacing: 15.0, // Khoảng cách giữa các hàng
          children: [
            // Nút "Sản phẩm"
            _buildMenuButton(
              context,
              icon: Icons.shopping_bag,
              label: 'Sản phẩm',
              color: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductListScreen(cart: _cart)),
                );
              },
            ),
            // Nút "Giỏ hàng"
            _buildMenuButton(
              context,
              icon: Icons.shopping_cart,
              label: 'Giỏ hàng',
              color: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen(cart: _cart)),
                );
              },
            ),
            // // Nút "Đơn hàng của khách hàng"
            // _buildMenuButton(
            //   context,
            //   icon: Icons.list_alt,
            //   label: 'Đơn hàng',
            //   color: Colors.orange,
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => CustomerOrdersScreen()),
            //     );
            //   },
            // ),
            // // Nút "Chỉnh sửa khách hàng"
            // _buildMenuButton(
            //   context,
            //   icon: Icons.edit,
            //   label: 'Chỉnh sửa',
            //   color: Colors.red,
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => EditCustomerScreen()),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  // Hàm tạo nút menu
  Widget _buildMenuButton(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onPressed}) {
    return Card(
      elevation: 5.0, // Đổ bóng cho Card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Bo góc Card
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15.0), // Bo góc InkWell
        splashColor: color.withOpacity(0.3), // Màu hiệu ứng khi nhấn
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(0.4),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50.0,
                  color: Colors.white, // Màu biểu tượng
                ),
                SizedBox(height: 10.0),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Màu chữ
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}