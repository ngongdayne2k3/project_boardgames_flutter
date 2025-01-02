import 'package:flutter/material.dart';
import 'package:project_boardgames_flutter/screens/cart_screen.dart';
import 'package:project_boardgames_flutter/screens/customer_profile_screen.dart';
import 'package:project_boardgames_flutter/screens/product_list_screen.dart';
import 'package:project_boardgames_flutter/screens/product_screen.dart';
import 'package:project_boardgames_flutter/models/cart.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final Cart cart; // Sử dụng `late` để khởi tạo sau
  late final List<Widget> _widgetOptions; // Sử dụng `late` để khởi tạo sau
  Widget? _currentProductScreen; // Màn hình chi tiết sản phẩm hiện tại

  @override
  void initState() {
    super.initState();
    cart = Cart(); // Khởi tạo `cart`
    _widgetOptions = <Widget>[
      ProductListScreen(
        cart: cart,
        onProductSelected: _onProductSelected, // Truyền callback để xử lý chọn sản phẩm
      ), // Truyền `cart` vào `ProductListScreen`
      CartScreen(cart: cart), // Truyền `cart` vào `CartScreen`
      CustomerProfile(), // Nếu CustomerProfile cần Cart, truyền vào đây
    ];
  }

  // Hàm xử lý khi người dùng chọn một sản phẩm
  void _onProductSelected(Map<String, dynamic> product) {
    setState(() {
      _currentProductScreen = ProductScreen(
        imageUrl: product['imageUrl'],
        productName: product['title'],
        productDescription: product['description'],
        price: product['price'],
        cart: cart,
        onContinueShopping: () {
          setState(() {
            _currentProductScreen = null; // Đóng màn hình chi tiết sản phẩm
          });
        },
        onCheckout: () {
          setState(() {
            _selectedIndex = 1; // Chuyển đến tab giỏ hàng
            _currentProductScreen = null; // Đóng màn hình chi tiết sản phẩm
          });
        },
        onBack: () {
          setState(() {
            _currentProductScreen = null; // Đóng màn hình chi tiết sản phẩm
          });
        },
      );
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _currentProductScreen = null; // Đóng màn hình chi tiết sản phẩm khi chuyển tab
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
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
      // Hiển thị màn hình chi tiết sản phẩm nếu có
      floatingActionButton: _currentProductScreen != null
          ? FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentProductScreen = null; // Đóng màn hình chi tiết sản phẩm
          });
        },
        child: Icon(Icons.close),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      // Hiển thị màn hình chi tiết sản phẩm
      bottomSheet: _currentProductScreen != null
          ? Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: _currentProductScreen,
      )
          : null,
    );
  }
}