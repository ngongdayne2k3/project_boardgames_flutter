import 'package:flutter/material.dart';
import 'package:project_boardgames_flutter/screens/admin/manage_products_screen.dart';
import 'package:project_boardgames_flutter/screens/main_screen.dart';
import 'package:project_boardgames_flutter/screens/auth/login_screen.dart';
import 'package:project_boardgames_flutter/screens/auth/signup_screen.dart';
import 'package:project_boardgames_flutter/screens/product_list_screen.dart';
import 'package:project_boardgames_flutter/screens/product_screen.dart';
import 'package:project_boardgames_flutter/screens/cart_screen.dart';
import 'package:project_boardgames_flutter/screens/customer_profile_screen.dart';
import 'package:project_boardgames_flutter/screens/admin/manage_order/manage_orders_screen.dart';
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
      routes: {
        '/': (context) => MainScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/product-list': (context) => ProductListScreen(
          cart: Cart(),
          onProductSelected: (productDetails) {
            print('Sản phẩm được chọn: $productDetails');
          },
        ),
        '/product': (context) => ProductScreen(
          imageUrl: '',
          productName: '',
          brand: '',
          category: '',
          productDescription: '',
          price: 0,
          cart: Cart(),
        ),
        '/cart': (context) => CartScreen(cart: Cart()),
        '/profile': (context) => CustomerProfile(),
        '/manage-products': (context) => ManageProductsScreen(),
        '/manage-orders': (context) => ManageOrdersScreen(),
      },
      initialRoute: '/',
    );
  }
}