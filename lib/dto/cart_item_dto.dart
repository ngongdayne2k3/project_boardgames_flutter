class CartItemDTO {
  final String productId;
  final String productName;
  final double price;
  int quantity;  // Số lượng có thể thay đổi

  CartItemDTO({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  // Chuyển đổi từ Map sang CartItemDTO
  factory CartItemDTO.fromMap(Map<String, dynamic> map) {
    return CartItemDTO(
      productId: map['productId'],
      productName: map['productName'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }

  // Chuyển đổi từ CartItemDTO sang Map
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
    };
  }
}