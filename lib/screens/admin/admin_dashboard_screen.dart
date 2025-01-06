import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, Admin!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/manage-products');
              },
              child: Text('Manage Products'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Điều hướng đến màn hình quản lý đơn hàng
              },
              child: Text('Manage Orders'),
            ),
          ],
        ),
      ),
    );
  }
}