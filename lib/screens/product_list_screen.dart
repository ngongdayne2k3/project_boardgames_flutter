import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'package:project_boardgames_flutter/models/cart.dart';
import '../models/board_game.dart';
import '../models/cart_item.dart';
import 'product_screen.dart';

class ProductListScreen extends StatefulWidget {
  final Cart cart;
  final Function(Map<String, dynamic>) onProductSelected;

  ProductListScreen({required this.cart, required this.onProductSelected});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<BoardGame> _products = [];
  List<BoardGame> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadProducts() async {
    List<BoardGame> products = await _dbHelper.getAllBoardGames();
    setState(() {
      _products = products;
      _filteredProducts = products;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((product) {
        final title = product.name?.toLowerCase() ?? '';
        final manufacturerName = product.brand?.name?.toLowerCase() ?? '';
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
        required BoardGame product,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              imageUrl: product.imageUrl ?? '',
              productName: product.name ?? 'Không có tên',
              brand: product.brand?.name ?? 'Không có thương hiệu',
              category: product.category?.name ?? 'Không có danh mục',
              productDescription: product.description ?? 'Không có mô tả',
              price: product.price ?? 0,
              cart: widget.cart,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(product.imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.image, color: Colors.grey[500]),
                ),
              SizedBox(width: 12),
              Expanded(
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
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  widget.cart.addItem(
                    product.id ?? '',
                    product.name ?? 'Không có tên',
                    product.price ?? 0,
                    1,
                  );

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