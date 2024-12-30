import 'package:flutter/material.dart';
import 'product_screen.dart';
import 'package:project_boardgames_flutter/models/cart.dart'; // Import model Cart

class ProductListScreen extends StatefulWidget {
  final Cart cart; // Nhận Cart từ MainScreen

  ProductListScreen({required this.cart}); // Constructor nhận Cart

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // Danh sách sản phẩm ban đầu
  final List<Map<String, String>> _products = [
    {
      'imageUrl': 'https://picsum.photos/200/200',
      'title': 'Sản phẩm 1',
      'description': 'Mô tả sản phẩm 1',
    },
    {
      'imageUrl': 'https://picsum.photos/200/200',
      'title': 'Sản phẩm 2',
      'description': 'Mô tả sản phẩm 2',
    },
    {
      'imageUrl': 'https://picsum.photos/200/200',
      'title': 'Sản phẩm 3',
      'description': 'Mô tả sản phẩm 3',
    },
  ];

  // Danh sách sản phẩm hiển thị (sẽ thay đổi khi tìm kiếm)
  List<Map<String, String>> _filteredProducts = [];

  // Controller để lấy giá trị từ TextField
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Khởi tạo danh sách hiển thị bằng danh sách ban đầu
    _filteredProducts = _products;
    // Lắng nghe sự thay đổi trong TextField
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    // Hủy controller khi widget bị hủy
    _searchController.dispose();
    super.dispose();
  }

  // Hàm xử lý khi từ khóa tìm kiếm thay đổi
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((product) {
        final title = product['title']!.toLowerCase();
        final description = product['description']!.toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    });
  }

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
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm sản phẩm',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Danh sách sản phẩm
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return _buildNewsItem(
                  context,
                  imageUrl: product['imageUrl']!,
                  title: product['title']!,
                  description: product['description']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(
      BuildContext context, {
        required String imageUrl,
        required String title,
        required String description,
      }) {
    return GestureDetector(
      onTap: () {
        // Điều hướng tới màn hình chi tiết sản phẩm
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              imageUrl: imageUrl,
              productName: title,
              productDescription: description,
              cart: widget.cart, // Truyền Cart vào ProductScreen
            ),
          ),
        );
      },
      child: Card(
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
              // Nội dung
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
      ),
    );
  }
}