import 'order_item.dart';
import 'user.dart';

class Order {
  int? id;
  String? recipientName;
  String? deliveryAddress;
  double? totalPrice;
  User? customer;
  List<OrderItem>? items;

  Order({this.id, this.recipientName, this.deliveryAddress, this.totalPrice, this.customer, this.items});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      recipientName: json['recipientName'],
      deliveryAddress: json['deliveryAddress'],
      totalPrice: json['totalPrice'],
      customer: json['customer'] != null ? User.fromJson(json['customer']) : null,
      items: (json['items'] as List).map((i) => OrderItem.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipientName': recipientName,
      'deliveryAddress': deliveryAddress,
      'totalPrice': totalPrice,
      'customer': customer?.toJson(),
      'items': items?.map((i) => i.toJson()).toList(),
    };
  }
}