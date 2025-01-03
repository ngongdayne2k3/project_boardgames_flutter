import 'cart_item.dart';

class Cart {
  final int? id;
  final List<CartItem> items;
  final String customerName;

  Cart({this.id, required this.items, required this.customerName});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      items: (json['items'] as List).map((item) => CartItem.fromJson(item)).toList(),
      customerName: json['customerName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'customerName': customerName,
    };
  }

  // void addProduct(String productName, String imageUrl) {
  //   items ??= []; // Khởi tạo danh sách items nếu nó null
  //   final existingItemIndex = items!.indexWhere((item) => item.productName == productName);
  //   if (existingItemIndex != -1) {
  //     items![existingItemIndex].quantity++;
  //   } else {
  //     items!.add(CartItem(productName: productName, imageUrl: imageUrl, quantity: 1));
  //   }
  // }
  //
  // void removeProduct(String productName) {
  //   items?.removeWhere((item) => item.productName == productName);
  // }
}