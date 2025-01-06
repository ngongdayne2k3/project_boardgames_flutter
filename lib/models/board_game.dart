import 'brand.dart';
import 'category.dart';

class BoardGame {
  String id;
  String name;
  Category category;
  Brand brand;
  double price;
  int stock;
  String description;
  String imageUrl;

  BoardGame({
    required this.id,
    required this.name,
    required this.category,
    required this.brand,
    required this.price,
    required this.stock,
    required this.description,
    required this.imageUrl,
  });

  // Kiểm tra xem sản phẩm còn hàng hay không
  bool isInStock() {
    return stock > 0;
  }

  // Giảm số lượng tồn kho khi bán hàng
  void decreaseStock(int quantity) {
    if (stock >= quantity) {
      stock -= quantity;
    } else {
      throw Exception('Not enough stock');
    }
  }

  // Tăng số lượng tồn kho khi nhập hàng
  void increaseStock(int quantity) {
    stock += quantity;
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'categoryId': category.id,
      'brandId': brand.id,
      'price': price,
      'stock': stock,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
  factory BoardGame.fromMap(Map<String, dynamic> map) {
    return BoardGame(
      id: map['id'],
      name: map['name'],
      category: Category(id: map['categoryId'], name: ''), // Giả sử category name không được lưu trong bảng boardgames
      brand: Brand(id: map['brandId'], name: ''), // Giả sử brand name không được lưu trong bảng boardgames
      price: map['price'],
      stock: map['stock'],
      description: map['description'],
      imageUrl: map['imageUrl'],
    );
  }
}