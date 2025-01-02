import 'package:flutter/material.dart';
import '../models/cart.dart';
import 'cart_screen.dart';

class ProductScreen extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String productDescription;
  final double price;
  final Cart cart;
  final VoidCallback onContinueShopping;
  final VoidCallback onCheckout;
  final VoidCallback onBack;

  ProductScreen({
    required this.imageUrl,
    required this.productName,
    required this.productDescription,
    required this.price,
    required this.cart,
    required this.onContinueShopping,
    required this.onCheckout,
    required this.onBack,
  });

  void _showPurchaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text('Bạn muốn tiếp tục mua hàng hay đến thanh toán?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onContinueShopping();
              },
              child: Text('Tiếp tục mua'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onCheckout();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(cart: cart),
                  ),
                );
              },
              child: Text('Đến thanh toán'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Giá: ${price.toString()} VND',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 8),
                        Text(
                          productDescription,
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              cart.addProduct(productName, imageUrl, price);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Đã thêm $productName vào giỏ hàng!')),
                              );
                              _showPurchaseDialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              backgroundColor: Colors.purple,
                            ),
                            child: Text(
                              'Mua hàng',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}