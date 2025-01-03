import 'product.dart';
import 'order.dart';

class OrderItem {
  final int? id;
  final Product product;
  final int quantity;
  final Order order;

  OrderItem({this.id, required this.product, required this.quantity, required this.order});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      order: Order.fromJson(json['order']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'order': order.toJson(),
    };
  }
}