import 'package:flutter/material.dart';
import 'package:project_boardgames_flutter/dbhelper//db_helper.dart'; // Import DatabaseHelper
import 'package:project_boardgames_flutter/models/cart.dart'; // Import model Cart
import 'package:project_boardgames_flutter/models/product.dart'; // Import model Product

class ProductListScreen extends StatefulWidget {
  final Cart cart; // Nhận Cart từ MainScreen
  final Function(Map<String, dynamic>) onProductSelected; // Callback khi chọn sản phẩm

  ProductListScreen({required this.cart, required this.onProductSelected}); // Constructor nhận Cart và callback

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = []; // Danh sách sản phẩm từ cơ sở dữ liệu
  List<Product> _filteredProducts = []; // Danh sách sản phẩm hiển thị
  final TextEditingController _searchController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper(); // Khởi tạo DatabaseHelper

  @override
  void initState() {
    super.initState();
    _loadProducts(); // Tải danh sách sản phẩm từ cơ sở dữ liệu
    _searchController.addListener(_onSearchChanged);
  }

  // Hàm tải danh sách sản phẩm từ cơ sở dữ liệu
  Future<void> _loadProducts() async {
    List<Product> products = await _dbHelper.getProducts();
    setState(() {
      _products = products;
      _filteredProducts = products;
    });
  }

  // Hàm xử lý khi từ khóa tìm kiếm thay đổi
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((product) {
        final title = product.name?.toLowerCase() ?? '';
        final manufacturerName = product.manufacturer?.name?.toLowerCase() ?? '';
        final categoryName = product.category?.name?.toLowerCase() ?? '';
        return title.contains(query) || manufacturerName.contains(query) || categoryName.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sản phẩm'),
      ),
      body: Column(
        children: [
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
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return _buildProductItem(
                  context,
                  product: product,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(
      BuildContext context, {
        required Product product,
      }) {
    return GestureDetector(
      onTap: () {
        widget.onProductSelected({
          'title': product.name ?? 'Không có tên',
          'price': product.price ?? 0,
          'manufacturer': product.manufacturer?.name ?? 'Không có nhà sản xuất',
          'category': product.category?.name ?? 'Không có danh mục',
        });
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? 'Không có tên',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              SizedBox(height: 8),
              Text(
                'Giá: ${product.price?.toString() ?? '0'} VND',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Nhà sản xuất: ${product.manufacturer?.name ?? 'Không có nhà sản xuất'}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Danh mục: ${product.category?.name ?? 'Không có danh mục'}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 8),
              IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  widget.cart.addProduct(product.name ?? 'Không có tên', '', product.price ?? 0);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã thêm ${product.name ?? "sản phẩm"} vào giỏ hàng!')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}