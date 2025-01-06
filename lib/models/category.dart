class Category {
  String id;
  String name;

  Category({
    required this.id,
    required this.name
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
    );
  }

  // Cập nhật thông tin danh mục
  void updateInfo({String? name}) {
    this.name = name ?? this.name;
    }
}