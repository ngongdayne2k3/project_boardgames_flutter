import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'admin_home_screen.dart';
import 'customer_home_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return FutureBuilder(
      future: authProvider.loadToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          if (authProvider.token != null) {
            if (authProvider.user?.role == Role.admin) {
              return AdminHomeScreen();
            } else {
              return CustomerHomeScreen();
            }
          } else {
            return LoginScreen();
          }
        }
      },
    );
  }
}