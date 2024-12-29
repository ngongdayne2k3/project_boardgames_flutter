import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sản phẩm'),
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Tìm kiếm sản phẩm',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Xử lý logic tìm kiếm sản phẩm
                print('Từ khóa tìm kiếm: $value');
              },
            ),
          ),
          // Danh sách sản phẩm
          Expanded(
            child: ListView(
              children: <Widget>[
                _buildNewsItem(
                  imageUrl: 'https://picsum.photos/200/200',
                  title: 'Tiêu đề bài viết 1',
                  description: 'Mô tả ngắn gọn về bài viết 1...',
                ),
                _buildNewsItem(
                  imageUrl: 'https://picsum.photos/200/200',
                  title: 'Tiêu đề bài viết 2',
                  description: 'Mô tả ngắn gọn về bài viết 2...',
                ),
                _buildNewsItem(
                  imageUrl: 'https://picsum.photos/200/200',
                  title: 'Tiêu đề bài viết 3',
                  description: 'Mô tả ngắn gọn về bài viết 3...',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem({
    required String imageUrl,
    required String title,
    required String description,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Hình ảnh
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12),
            // Nội dung (Tiêu đề và mô tả)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
