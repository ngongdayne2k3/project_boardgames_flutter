class Category {
  String id;
  String name;

  Category({
    required this.id,
    required this.name
  });

  // Cập nhật thông tin danh mục
  void updateInfo({String? name}) {
    this.name = name ?? this.name;
    }
}