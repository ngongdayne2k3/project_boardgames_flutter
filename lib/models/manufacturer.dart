class Manufacturer {
  final int? id;
  final String name;
  final String address;
  final String phoneNumber;

  Manufacturer({this.id, required this.name, required this.address, required this.phoneNumber});

  factory Manufacturer.fromJson(Map<String, dynamic> json) {
    return Manufacturer(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }
}