import 'category.dart';
import 'manufacturer.dart';

class Product {
  int? id;
  String? name;
  double? price;
  Manufacturer? manufacturer;
  Category? category;

  Product({this.id, this.name, this.price, this.manufacturer, this.category});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      manufacturer: json['manufacturer'] != null ? Manufacturer.fromJson(json['manufacturer']) : null,
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'manufacturer': manufacturer?.toJson(),
      'category': category?.toJson(),
    };
  }
}