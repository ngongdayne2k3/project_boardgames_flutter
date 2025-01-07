class OrderItem {
  String productId;
  String productName;
  double price;
  int quantity;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  // Tính tổng giá của mục này
  double getTotalPrice() {
    return price * quantity;
  }
}