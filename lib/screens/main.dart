import 'package:flutter/material.dart';
import 'package:project_boardgames_flutter/screens/admin_home_screen.dart';
import 'package:provider/provider.dart';
import '../screen/screen3/auth_provider.dart';
import '../screen/screen3/product_provider.dart';
import '../screen/screen3/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth System',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: AdminHomeScreen(),
      ),
    );
  }
}