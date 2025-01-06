class Brand {
  String id;
  String name;

  Brand({
    required this.id,
    required this.name
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Brand.fromMap(Map<String, dynamic> map) {
    return Brand(
      id: map['id'],
      name: map['name'],
    );
  }

  // Cập nhật thông tin thương hiệu
  void updateInfo({String? name}) {
    this.name = name ?? this.name;
  }
}