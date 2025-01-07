import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_boardgames_flutter/screens/auth/login_screen.dart';
import 'package:project_boardgames_flutter/screens/product_list_screen.dart';
import 'package:project_boardgames_flutter/screens/cart_screen.dart';
import 'package:project_boardgames_flutter/models/cart.dart';
import 'package:project_boardgames_flutter/screens/admin/manage_products_screen.dart'; // Thêm import này
import 'package:project_boardgames_flutter/screens/admin/manage_order/manage_orders_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isLoggedIn = false;
  String? _userRole;
  final Cart _cart = Cart();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userRole = prefs.getString('userRole');

    if (!isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      setState(() {
        _isLoggedIn = true;
        _userRole = userRole;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
        backgroundColor: Colors.deepPurple,
        elevation: 10.0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              await prefs.remove('userId');
              await prefs.remove('userRole');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
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
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(20.0),
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 15.0,
          children: [
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
                        print('Sản phẩm được chọn: $productDetails');
                      },
                    ),
                  ),
                );
              },
            ),
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
            if (_userRole == 'admin')
              _buildMenuButton(
                context,
                icon: Icons.manage_search,
                label: 'Quản lý sản phẩm',
                color: Colors.orange,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManageProductsScreen()),
                  );
                },
              ),
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

  Widget _buildMenuButton(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onPressed}) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15.0),
        splashColor: color.withOpacity(0.3),
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
                  color: Colors.white,
                ),
                SizedBox(height: 10.0),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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