import 'package:flutter/material.dart';
import 'package:project_boardgames_flutter/screens/customer_profile_screen.dart';
import 'package:project_boardgames_flutter/screens/product_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOption = <Widget>[
    ProductScreen(),
    CustomerProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:  _widgetOption.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ sản phẩm'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.yellow,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
