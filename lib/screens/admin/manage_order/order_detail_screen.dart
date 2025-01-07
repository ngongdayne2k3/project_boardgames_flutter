import 'package:flutter/material.dart';
import 'package:project_boardgames_flutter/dto/order_info_dto.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderInfoDTO order;

  OrderDetailScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đơn hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mã đơn hàng: ${order.orderId}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Khách hàng: ${order.customerName}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Địa chỉ: ${order.customerAddress ?? "N/A"}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Số điện thoại: ${order.customerPhoneNumber ?? "N/A"}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Email: ${order.customerEmail ?? "N/A"}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Sản phẩm:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return ListTile(
                    title: Text(item.productName),
                    subtitle: Text('Giá: \$${item.price} - Số lượng: ${item.quantity}'),
                  );
                },
              ),
            ),
            Text('Tổng tiền: \$${order.totalAmount}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}