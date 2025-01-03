import 'manufacturer.dart';
import 'category.dart';

class Product {
  final int? id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final int stockQuantity;
  final Manufacturer manufacturer;
  final Category category;

  Product({this.id, required this.name, required this.price, required this.imageUrl, required this.description, required this.stockQuantity, required this.manufacturer, required this.category});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      stockQuantity: json['stockQuantity'],
      manufacturer: Manufacturer.fromJson(json['manufacturer']),
      category: Category.fromJson(json['category']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'stockQuantity': stockQuantity,
      'manufacturer': manufacturer.toJson(),
      'category': category.toJson(),
    };
  }
}