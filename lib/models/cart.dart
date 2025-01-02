

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
}