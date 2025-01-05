import 'package:flutter/material.dart';
import 'package:project_boardgames_flutter/screens/main_screen.dart';
import 'package:project_boardgames_flutter/screens/login_screen.dart';
import 'package:project_boardgames_flutter/screens/signup_screen.dart';
import 'package:project_boardgames_flutter/screens/product_list_screen.dart';
import 'package:project_boardgames_flutter/screens/product_screen.dart';
import 'package:project_boardgames_flutter/screens/cart_screen.dart';
import 'package:project_boardgames_flutter/screens/customer_profile_screen.dart';

import 'models/cart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Định nghĩa các route
      routes: {
        '/': (context) => MainScreen(),  // Route mặc định (Home)
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/product-list': (context) => ProductListScreen(cart: Cart()),  // Truyền Cart vào ProductListScreen
        '/product': (context) => ProductScreen(
          imageUrl: '',  // Truyền các giá trị cần thiết
          productName: '',
          productDescription: '',
          cart: Cart(),
        ),
        '/cart': (context) => CartScreen(cart: Cart()),  // Truyền Cart vào CartScreen
        '/profile': (context) => CustomerProfile(),
      },
      initialRoute: '/',  // Route khởi đầu
    );
  }
}