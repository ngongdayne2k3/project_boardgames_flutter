import 'package:flutter/material.dart';
import '../services/order_service.dart'; // Sử dụng service trực tiếp
import '../models/order.dart';

class CustomerDetailScreen extends StatefulWidget {
  final int customerId;

  CustomerDetailScreen({required this.customerId});

  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  List<Order> _orders = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    try {
      _orders = await OrderService.getOrdersByCustomerId(widget.customerId);
    } catch (e) {
      print('Error fetching orders: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer Details')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          return ListTile(
            title: Text('Order ID: ${order.id}'),
            subtitle: Text('Status: ${order.status}'),
          );
        },
      ),
    );
  }
}