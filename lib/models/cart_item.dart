class CartItem {
  final String productName;
  final String imageUrl;
  final double price; // Thêm trường giá sản phẩm
  int quantity;

  CartItem({
    required this.productName,
    required this.imageUrl,
    required this.price, // Thêm giá sản phẩm
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productName: json['productName'],
      imageUrl: json['imageUrl'],
      price: json['price'], // Đọc giá từ JSON
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'imageUrl': imageUrl,
      'price': price, // Ghi giá vào JSON
      'quantity': quantity,
    };
  }
}