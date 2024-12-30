import 'User.dart';

class Shop {
  int? id;
  String? name;
  String? location;
  User? manager;

  Shop({this.id, this.name, this.location, this.manager});

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      manager: json['manager'] != null ? User.fromJson(json['manager']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'manager': manager?.toJson(),
    };
  }
}