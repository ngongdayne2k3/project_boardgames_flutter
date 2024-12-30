import 'Product.dart';

class Manufacturer {
  int? id;
  String? name;
  String? address;
  String? phoneNumber;
  List<Product>? products;

  Manufacturer({this.id, this.name, this.address, this.phoneNumber, this.products});

  factory Manufacturer.fromJson(Map<String, dynamic> json) {
    return Manufacturer(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      products: (json['products'] as List).map((i) => Product.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'products': products?.map((i) => i.toJson()).toList(),
    };
  }
}