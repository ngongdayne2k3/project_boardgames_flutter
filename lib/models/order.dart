import 'order_item.dart';
import 'user.dart';

class Order {
  int? id;
  String? recipientName;
  String? deliveryAddress;
  double? totalPrice;
  User? customer;
  List<OrderItem>? items;
  String? status; // Trạng thái đơn hàng
  String? reason; // Lý do nếu đơn hàng thất bại

  Order({
    this.id,
    this.recipientName,
    this.deliveryAddress,
    this.totalPrice,
    this.customer,
    this.items,
    this.status = 'Đang xử lý', // Mặc định là "Đang xử lý"
    this.reason,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      recipientName: json['recipientName'],
      deliveryAddress: json['deliveryAddress'],
      totalPrice: json['totalPrice'],
      customer: json['customer'] != null ? User.fromJson(json['customer']) : null,
      items: (json['items'] as List).map((i) => OrderItem.fromJson(i)).toList(),
      status: json['status'],
      reason: json['reason'],
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
      'status': status,
      'reason': reason,
    };
  }
}