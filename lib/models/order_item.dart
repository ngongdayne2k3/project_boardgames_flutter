import 'order.dart';
import 'product.dart';

class OrderItem {
  int? id;
  Product? product;
  int? quantity;
  Order? order;

  OrderItem({this.id, this.product, this.quantity, this.order});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
      quantity: json['quantity'],
      order: json['order'] != null ? Order.fromJson(json['order']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product?.toJson(),
      'quantity': quantity,
      'order': order?.toJson(),
    };
  }
}