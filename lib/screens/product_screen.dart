import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String productDescription;

  ProductScreen({
    required this.imageUrl,
    required this.productName,
    required this.productDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: Center(
        // Đặt toàn bộ nội dung ở giữa màn hình
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều ngang
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ảnh sản phẩm
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  SizedBox(width: 20),
                  // Thông tin sản phẩm
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
                          productDescription,
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 20),
                        // Nút Mua hàng căn phải
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              // Xử lý logic khi nhấn nút Mua hàng
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Bạn đã chọn mua $productName!')),
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
