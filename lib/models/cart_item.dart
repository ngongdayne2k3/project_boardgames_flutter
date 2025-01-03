import 'cart.dart';
import 'product.dart';

class CartItem {
  final int? id;
  final Cart cart;
  final Product product;
  final int quantity;
  final double price;

  CartItem({this.id, required this.cart, required this.product, required this.quantity, required this.price});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      cart: Cart.fromJson(json['cart']),
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart': cart.toJson(),
      'product': product.toJson(),
      'quantity': quantity,
      'price': price,
    };
  }
}