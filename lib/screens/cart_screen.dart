import 'package:flutter/material.dart';
import '../models/cart.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;

  CartScreen({required this.cart});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.items?.length ?? 0,
              itemBuilder: (context, index) {
                final item = widget.cart.items![index];
                return ListTile(
                  title: Text(item.productName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          Text('Số lượng:'),
                          Expanded(
                            child: Row(
                              children: [
                                // Nút giảm số lượng
                                Container(
                                  width: 30, // Đặt kích thước chiều rộng
                                  height: 30, // Đặt kích thước chiều cao
                                  alignment: Alignment.center, // Căn giữa biểu tượng
                                  child: IconButton(
                                    icon: Icon(Icons.remove),
                                    iconSize: 24,
                                    padding: EdgeInsets.zero, // Loại bỏ padding mặc định
                                    onPressed: () {
                                      setState(() {
                                        if (item.quantity > 1) {
                                          widget.cart.updateQuantity(item.productId, item.quantity - 1); // Giảm số lượng
                                        } else {
                                          widget.cart.removeItem(item.productId); // Xóa sản phẩm nếu số lượng = 0
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text('${item.quantity}'),
                                const SizedBox(width: 2),
                                // Nút tăng số lượng
                                Container(
                                  width: 30, // Đặt kích thước chiều rộng
                                  height: 30, // Đặt kích thước chiều cao
                                  alignment: Alignment.center, // Căn giữa biểu tượng
                                  child: IconButton(
                                    icon: Icon(Icons.add),
                                    iconSize: 24,
                                    padding: EdgeInsets.zero, // Loại bỏ padding mặc định
                                    onPressed: () {
                                      setState(() {
                                        widget.cart.updateQuantity(item.productId, item.quantity + 1); // Tăng số lượng
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Nút "bỏ" (xóa sản phẩm)
                      IconButton(
                        icon: Icon(Icons.remove_shopping_cart),
                        onPressed: () {
                          setState(() {
                            widget.cart.removeItem(item.productId); // Xóa sản phẩm
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đã xóa ${item.productName} khỏi giỏ hàng!')),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Hiển thị tổng tiền
          Container(
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Tổng tiền: ${widget.cart.getTotalAmount().toStringAsFixed(2)} VND',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Xử lý thanh toán
                  },
                  child: Text('Thanh toán'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}