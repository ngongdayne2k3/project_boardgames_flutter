import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:project_boardgames_flutter/models/user.dart';
import 'package:project_boardgames_flutter/models/order.dart';

class CustomerDetailScreen extends StatelessWidget {
  final User customer;

  CustomerDetailScreen({required this.customer});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${customer.name}', style: TextStyle(fontSize: 18)),
            Text('Email: ${customer.email}', style: TextStyle(fontSize: 18)),
            Text('Phone: ${customer.phoneNumber}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Orders:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: customer.orders?.length ?? 0,
                itemBuilder: (context, index) {
                  final order = customer.orders![index];
                  return ListTile(
                    title: Text('Order ID: ${order.id}'),
                    subtitle: Text('Status: ${order.status ?? "Đang xử lý"}'), // Hiển thị mặc định nếu status là null
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showUpdateOrderStatusDialog(context, authProvider, order);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateOrderStatusDialog(BuildContext context, AuthProvider authProvider, Order order) {
    String newStatus = order.status ?? 'Đang xử lý';
    String? reason;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Order Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: newStatus,
                items: ['Đang xử lý', 'Đã đặt hàng thành công, đang vận chuyển', 'Đặt hàng thất bại']
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) {
                  newStatus = value!;
                },
              ),
              if (newStatus == 'Đặt hàng thất bại')
                TextField(
                  decoration: InputDecoration(labelText: 'Lý do'),
                  onChanged: (value) {
                    reason = value;
                  },
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                authProvider.updateOrderStatus(order.id!, newStatus, reason: reason);
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}