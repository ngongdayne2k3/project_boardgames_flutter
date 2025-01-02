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

  void addProduct(String productName, String imageUrl, double price) {
    items ??= [];
    final existingItemIndex = items!.indexWhere((item) => item.productName == productName);
    if (existingItemIndex != -1) {
      items![existingItemIndex].quantity++;
    } else {
      items!.add(CartItem(productName: productName, imageUrl: imageUrl, price: price, quantity: 1));
    }
  }

  void removeProduct(String productName) {
    items?.removeWhere((item) => item.productName == productName);
  }

  double getTotalPrice() {
    double total = 0;
    if (items != null) {
      for (var item in items!) {
        total += item.price * item.quantity;
      }
    }
    return total;
  }
}