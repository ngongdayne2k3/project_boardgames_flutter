import '../dto/cart_dto.dart';
import '../dto/cart_item_dto.dart';

class Cart {
  List<CartItemDTO> items = [];

  // Thêm sản phẩm vào giỏ hàng
  void addItem(String productId, String productName, double price, int quantity) {
    // Tìm kiếm sản phẩm đã tồn tại trong giỏ hàng
    var existingItemIndex = items.indexWhere((item) => item.productId == productId);

    if (existingItemIndex != -1) {
      // Nếu sản phẩm đã tồn tại, tăng số lượng lên 1
      items[existingItemIndex].quantity += quantity;
    } else {
      // Nếu sản phẩm chưa tồn tại, thêm sản phẩm mới vào giỏ hàng
      items.add(CartItemDTO(
        productId: productId,
        productName: productName,
        price: price,
        quantity: quantity,
      ));
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  void removeItem(String productId) {
    items.removeWhere((item) => item.productId == productId);
  }

  // Cập nhật số lượng sản phẩm trong giỏ hàng
  void updateQuantity(String productId, int newQuantity) {
    final item = items.firstWhere(
          (item) => item.productId == productId,
      orElse: () => throw Exception('Product not found in cart'),
    );

    if (newQuantity > 0) {
      item.quantity = newQuantity;
    } else {
      removeItem(productId);  // Xóa sản phẩm nếu số lượng <= 0
    }
  }

  // Tính tổng tiền trong giỏ hàng
  double getTotalAmount() {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Xóa toàn bộ giỏ hàng
  void clearCart() {
    items.clear();
  }

  // Chuyển đổi giỏ hàng thành CartDTO
  CartDTO toCartDTO() {
    return CartDTO(
      items: items,
      totalAmount: getTotalAmount(),
    );
  }
}