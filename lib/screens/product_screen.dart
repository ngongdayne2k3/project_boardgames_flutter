import 'package:flutter/material.dart';
import '../dto/cart_item_dto.dart';
import '../models/cart.dart';
import 'cart_screen.dart';

class ProductScreen extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String brand;
  final String category;
  final String productDescription;
  final double price;
  final Cart cart;

  ProductScreen({
    required this.imageUrl,
    required this.productName,
    required this.brand,
    required this.category,
    required this.productDescription,
    required this.price,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cart: cart),
                ),
              );
            },
          ),
        ],
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
                          'Thương hiệu: $brand',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Danh mục: $category',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 8),
                        // Sử dụng SingleChildScrollView để làm cho mô tả có thể cuộn được
                        Container(
                          height: 200,
                          child: SingleChildScrollView(
                            child: Text(
                              productDescription,
                              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              CartItemDTO newItem = CartItemDTO(
                                productId: productName,
                                productName: productName,
                                price: price,
                                quantity: 1,
                              );

                              cart.addItem(
                                newItem.productId,
                                newItem.productName,
                                newItem.price,
                                newItem.quantity,
                              );

                              // Hiển thị SnackBar khi thêm sản phẩm vào giỏ hàng
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Đã thêm $productName vào giỏ hàng!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
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