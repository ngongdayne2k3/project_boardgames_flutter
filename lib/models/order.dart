import 'cart_item.dart';
import 'order_item.dart';
import 'user.dart';

class Order {
  String id;
  User customer;
  List<OrderItem> items;
  double totalAmount;
  String status; // 'successful', 'processing', 'cancelled'
  String paymentMethod; // 'COD'

  Order({
    required this.id,
    required this.customer,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
  });

  // Tính tổng tiền của đơn hàng
  double calculateTotalAmount() {
    return items.fold(0, (sum, item) => sum + item.getTotalPrice());
  }

  // Cập nhật trạng thái đơn hàng
  void updateStatus(String newStatus) {
    if (['successful', 'processing', 'cancelled'].contains(newStatus)) {
      status = newStatus;
    } else {
      throw Exception('Invalid status');
    }
  }

  // Chuyển đổi CartItem thành OrderItem
  static List<OrderItem> convertCartItemsToOrderItems(List<CartItem> cartItems) {
    return cartItems.map((cartItem) {
      return OrderItem(
        productId: cartItem.product.id,
        productName: cartItem.product.name,
        price: cartItem.product.price,
        quantity: cartItem.quantity,
      );
    }).toList();
  }
}