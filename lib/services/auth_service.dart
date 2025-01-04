import '../database/database_helper.dart';
import '../models/user.dart';
import '../models/user_role.dart';
import '../dto/login_dto.dart';  // Import LoginDTO

class AuthService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Đăng ký người dùng mới
  Future<bool> signup({
    required String name,
    required String username,
    required String? email,
    required String? phoneNumber,
    required String password,
    required UserRole role,
  }) async {
    if (email == null && phoneNumber == null) {
      throw Exception('Email or phoneNumber must be provided');
    }

    // Kiểm tra xem email hoặc số điện thoại đã tồn tại chưa
    final existingUser = await _dbHelper.getUserByEmailOrPhone(email ?? '', phoneNumber ?? '');
    if (existingUser != null) {
      return false; // Email hoặc số điện thoại đã tồn tại
    }

    // Tạo người dùng mới
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      address: null, // Địa chỉ có thể null
      avatarUrl: null, // Avatar có thể null
      role: role,
      password: password,
    );

    // Thêm người dùng vào cơ sở dữ liệu
    await _dbHelper.insertUser(user);
    return true;
  }

  // Đăng nhập sử dụng LoginDTO
  Future<User?> login(LoginDTO loginDTO) async {
    // Lấy người dùng bằng username
    final user = await _dbHelper.getUserByUsername(loginDTO.username);
    if (user != null && user.password == loginDTO.password) {
      return user; // Đăng nhập thành công
    }
    return null; // Đăng nhập thất bại
  }

  // Đăng xuất
  Future<void> logout() async {
    // Xử lý đăng xuất (nếu cần)
  }

  // Kiểm tra xem người dùng có phải là admin không
  Future<bool> isAdmin(User user) async {
    final dbUser = await _dbHelper.getUserById(user.id);
    return dbUser?.role == UserRole.admin;
  }

  // Lấy thông tin người dùng hiện tại
  Future<User?> getCurrentUser(String userId) async {
    return await _dbHelper.getUserById(userId);
  }

  // Cập nhật thông tin người dùng
  Future<void> updateUser(User user) async {
    if (!user.isValid()) {
      throw Exception('Email or phoneNumber must be provided');
    }
    await _dbHelper.updateUser(user);
  }

  // Xóa người dùng
  Future<void> deleteUser(String userId) async {
    await _dbHelper.deleteUser(userId);
  }
}