import 'cart_item_dto.dart';  // Import CartItemDTO

class CartDTO {
  final List<CartItemDTO> items;
  final double totalAmount;

  CartDTO({
    required this.items,
    required this.totalAmount,
  });

  // Chuyển đổi từ Map sang CartDTO
  factory CartDTO.fromMap(Map<String, dynamic> map) {
    return CartDTO(
      items: List<CartItemDTO>.from(
        map['items'].map((item) => CartItemDTO.fromMap(item)),
      ),
      totalAmount: map['totalAmount'],
    );
  }

  // Chuyển đổi từ CartDTO sang Map
  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
    };
  }
}