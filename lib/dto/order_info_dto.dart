import '../models/order_item.dart';

class OrderInfoDTO {
  final String orderId;
  final String customerName;
  final String? customerAddress;
  final String? customerPhoneNumber;
  final String? customerEmail;
  final double totalAmount;
  final String status;
  final String paymentMethod;
  final List<OrderItem> items;

  OrderInfoDTO({
    required this.orderId,
    required this.customerName,
    this.customerAddress,
    this.customerPhoneNumber,
    this.customerEmail,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.items,
  });

  // Chuyển đổi từ Map sang OrderInfoDTO
  factory OrderInfoDTO.fromMap(Map<String, dynamic> orderMap, List<OrderItem> items) {
    return OrderInfoDTO(
      orderId: orderMap['id'],
      customerName: orderMap['name'],
      customerAddress: orderMap['address'],
      customerPhoneNumber: orderMap['phoneNumber'],
      customerEmail: orderMap['email'],
      totalAmount: orderMap['totalAmount'],
      status: orderMap['status'],
      paymentMethod: orderMap['paymentMethod'],
      items: items,
    );
  }
}