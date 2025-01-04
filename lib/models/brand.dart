class Brand {
  String id;
  String name;

  Brand({
    required this.id,
    required this.name
  });

  // Cập nhật thông tin thương hiệu
  void updateInfo({String? name}) {
    this.name = name ?? this.name;
  }
}