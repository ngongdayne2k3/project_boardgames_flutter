import 'cart.dart';

class CartItem {
  final String productName;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.productName,
    required this.imageUrl,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productName: json['productName'],
      imageUrl: json['imageUrl'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }
}