import 'package:flutter/material.dart';
import 'package:project_boardgames_flutter/screen/screen3/manage_customer_screen.dart';
import 'ManageProducts_screen.dart';
import 'customer_detail_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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