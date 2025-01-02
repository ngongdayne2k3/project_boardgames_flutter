import 'cart_item.dart';

class Cart {
  int? id;
  String? customerName;
  List<CartItem>? items;

  Cart({this.id, this.customerName, this.items});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      customerName: json['customerName'],
      items: (json['items'] as List).map((i) => CartItem.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'items': items?.map((i) => i.toJson()).toList(),
    };
  }

  void addProduct(String productName, String imageUrl) {
    items ??= []; // Khởi tạo danh sách items nếu nó null
    final existingItemIndex = items!.indexWhere((item) => item.productName == productName);
    if (existingItemIndex != -1) {
      items![existingItemIndex].quantity++;
    } else {
      items!.add(CartItem(productName: productName, imageUrl: imageUrl, quantity: 1));
    }
  }

  void removeProduct(String productName) {
    items?.removeWhere((item) => item.productName == productName);
  }
}