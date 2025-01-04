import 'board_game.dart';

class CartItem {
  BoardGame product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  // Tính tổng giá của mục này
  double getTotalPrice() {
    return product.price * quantity;
  }

  // Cập nhật số lượng
  void updateQuantity(int newQuantity) {
    if (newQuantity > 0) {
      quantity = newQuantity;
    } else {
      throw Exception('Quantity must be greater than 0');
    }
  }
}