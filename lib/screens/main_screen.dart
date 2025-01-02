import 'package:flutter/material.dart';
import 'package:project_boardgames_flutter/screens/cart_screen.dart';
import 'package:project_boardgames_flutter/screens/customer_profile_screen.dart';
import 'package:project_boardgames_flutter/screens/product_list_screen.dart';
import 'package:project_boardgames_flutter/models/cart.dart'; // Import model Cart

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final Cart cart; // Sử dụng `late` để khởi tạo sau
  late final List<Widget> _widgetOptions; // Sử dụng `late` để khởi tạo sau

  @override
  void initState() {
    super.initState();
    cart = Cart(); // Khởi tạo `cart`
    _widgetOptions = <Widget>[
      ProductListScreen(cart: cart), // Truyền `cart` vào `ProductListScreen`
      CartScreen(cart: cart), // Truyền `cart` vào `CartScreen`
      CustomerProfile(), // Nếu CustomerProfile cần Cart, truyền vào đây
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ sản phẩm'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Giỏ hàng'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow,
        onTap: _onItemTapped,
      ),
    );
  }
}