import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'manage_customer_screen.dart';
import 'manage_products_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.user?.role != Role.admin) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Access Denied'),
        ),
        body: Center(
          child: Text('You do not have permission to access this page.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Manage Products'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageProductsScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Manage Customers'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageCustomersScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}