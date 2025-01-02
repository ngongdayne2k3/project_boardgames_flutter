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
      body: ListView.builder(
        itemCount: widget.cart.items?.length ?? 0,
        itemBuilder: (context, index) {
          final item = widget.cart.items![index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(item.imageUrl),
            ),
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
                                    item.quantity--; // Giảm số lượng
                                  } else {
                                    widget.cart.removeProduct(item.productName); // Xóa sản phẩm nếu số lượng = 0
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
                                  item.quantity++; // Tăng số lượng
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
                      widget.cart.removeProduct(item.productName); // Xóa sản phẩm
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
    );
  }
}