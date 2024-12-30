import 'Cart.dart';

class CartItem {
  int? id;
  String? productName;
  int? quantity;
  double? price;
  Cart? cart;

  CartItem({this.id, this.productName, this.quantity, this.price, this.cart});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productName: json['productName'],
      quantity: json['quantity'],
      price: json['price'],
      cart: json['cart'] != null ? Cart.fromJson(json['cart']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'cart': cart?.toJson(),
    };
  }
}