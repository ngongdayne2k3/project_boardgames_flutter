import 'product.dart';

class Category {
  int? id;
  String? name;
  List<Product>? products;

  Category({this.id, this.name, this.products});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      products: (json['products'] as List).map((i) => Product.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'products': products?.map((i) => i.toJson()).toList(),
    };
  }
}