import 'user.dart';
import 'order_item.dart';
import 'order_status.dart';

class Order {
  final int? id;
  final String recipientName;
  final String deliveryAddress;
  final double totalPrice;
  final User customer;
  final List<OrderItem> items;
  final OrderStatus status;

  Order({this.id, required this.recipientName, required this.deliveryAddress, required this.totalPrice, required this.customer, required this.items, required this.status});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      recipientName: json['recipientName'],
      deliveryAddress: json['deliveryAddress'],
      totalPrice: json['totalPrice'],
      customer: User.fromJson(json['customer']),
      items: (json['items'] as List).map((item) => OrderItem.fromJson(item)).toList(),
      status: OrderStatus.values.firstWhere((e) => e.toString() == 'OrderStatus.${json['status']}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipientName': recipientName,
      'deliveryAddress': deliveryAddress,
      'totalPrice': totalPrice,
      'customer': customer.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'status': status.toString().split('.').last,
    };
  }
}