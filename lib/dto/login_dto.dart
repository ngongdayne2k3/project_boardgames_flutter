class LoginDTO {
  final String username;
  final String password;

  LoginDTO({
    required this.username,
    required this.password,
  });

  // Chuyển đổi từ Map sang LoginDTO
  factory LoginDTO.fromMap(Map<String, dynamic> map) {
    return LoginDTO(
      username: map['username'],
      password: map['password'],
    );
  }

  // Chuyển đổi từ LoginDTO sang Map
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }
}