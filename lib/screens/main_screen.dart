import 'package:flutter/material.dart';
import 'package:project_boardgames_flutter/screens/admin/manage_order/manage_orders_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_boardgames_flutter/screens/auth/login_screen.dart';
import 'package:project_boardgames_flutter/screens/product_list_screen.dart';
import 'package:project_boardgames_flutter/screens/cart_screen.dart';
import 'package:project_boardgames_flutter/models/cart.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  bool _isLoggedIn = false;
  String? _userRole; // Lưu vai trò của người dùng
  final Cart _cart = Cart(); // Giỏ hàng

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Đăng ký theo dõi vòng đời
    _checkLoginStatus(); // Kiểm tra trạng thái đăng nhập khi khởi tạo
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Hủy đăng ký khi widget bị hủy
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Khi ứng dụng trở lại trạng thái hoạt động, kiểm tra lại trạng thái đăng nhập
      _checkLoginStatus();
    }
  }

  // Hàm kiểm tra trạng thái đăng nhập
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // Lấy trạng thái đăng nhập
    final userRole = prefs.getString('userRole'); // Lấy vai trò của người dùng

    if (!isLoggedIn) {
      // Nếu chưa đăng nhập, chuyển hướng đến LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      // Nếu đã đăng nhập, cập nhật trạng thái và vai trò
      setState(() {
        _isLoggedIn = true;
        _userRole = userRole;
      });
    }
  }

  // Hàm hiển thị hộp thoại xác nhận đăng xuất
  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Người dùng phải nhấn một nút để đóng hộp thoại
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận đăng xuất'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc chắn muốn đăng xuất không?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
            TextButton(
              child: Text('Đăng xuất'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                await prefs.remove('userId');
                await prefs.remove('userRole');
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false, // Xóa toàn bộ ngăn xếp điều hướng
                );
              },
            ),
          ],
        );
      },
    );
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
        actions: [
          // Nút đăng xuất
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
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
                  MaterialPageRoute(
                    builder: (context) => ProductListScreen(
                      cart: _cart,
                      onProductSelected: (productDetails) {
                        // Xử lý khi sản phẩm được chọn
                        print('Sản phẩm được chọn: $productDetails');
                      },
                    ),
                  ),
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
            // Nút "Quản lý sản phẩm" (chỉ hiển thị cho admin)
            if (_userRole == 'admin')
              _buildMenuButton(
                context,
                icon: Icons.manage_search,
                label: 'Quản lý sản phẩm',
                color: Colors.orange,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManageOrdersScreen()),
                  );
                },
              ),
            // Nút "Quản lý đơn hàng" (chỉ hiển thị cho admin)
            if (_userRole == 'admin')
              _buildMenuButton(
                context,
                icon: Icons.list_alt,
                label: 'Quản lý đơn hàng',
                color: Colors.red,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManageOrdersScreen()),
                  );
                },
              ),
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