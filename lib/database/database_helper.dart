import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../dto/order_info_dto.dart';
import '../models/user.dart';
import '../models/order.dart';
import '../models/order_item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Tạo singleton
  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  // Khởi tạo cơ sở dữ liệu
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Khởi tạo và mở cơ sở dữ liệu
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'boardgames.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Tạo bảng khi cơ sở dữ liệu được tạo lần đầu
  Future<void> _onCreate(Database db, int version) async {
    // Tạo bảng users
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT,
        username TEXT UNIQUE,
        email TEXT,
        phoneNumber TEXT,
        address TEXT,
        avatarUrl TEXT,
        role TEXT,
        password TEXT
      )
    ''');

    // Tạo bảng boardgames
    await db.execute('''
      CREATE TABLE boardgames (
        id TEXT PRIMARY KEY,
        name TEXT,
        categoryId TEXT,
        brandId TEXT,
        price REAL,
        stock INTEGER,
        description TEXT,
        imageUrl TEXT
      )
    ''');

    // Tạo bảng categories
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT
      )
    ''');

    // Tạo bảng brands
    await db.execute('''
      CREATE TABLE brands (
        id TEXT PRIMARY KEY,
        name TEXT
      )
    ''');

    // Tạo bảng orders
    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        customerId TEXT,
        totalAmount REAL,
        status TEXT,
        paymentMethod TEXT
      )
    ''');

    // Tạo bảng order_items
    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        orderId TEXT,
        productId TEXT,
        productName TEXT,
        price REAL,
        quantity INTEGER
      )
    ''');
  }

  // Đóng cơ sở dữ liệu
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }

  // Thêm người dùng mới
  Future<void> insertUser(User user) async {
    if (!user.isValid()) {
      throw Exception('Email or phoneNumber must be provided');
    }

    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Lấy người dùng bằng id
  Future<User?> getUserById(String id) async {
    final db = await database;

    // Thực hiện truy vấn SQL để lấy người dùng dựa trên id
    final List<Map<String, dynamic>> maps = await db.query(
      'users',  // Tên bảng
      where: 'id = ?',  // Điều kiện WHERE
      whereArgs: [id],  // Giá trị của điều kiện
    );

    // Nếu có kết quả, chuyển đổi thành đối tượng User
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }

    // Trả về null nếu không tìm thấy người dùng
    return null;
  }

  // Lấy người dùng bằng username
  Future<User?> getUserByUsername(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Lấy người dùng bằng email hoặc số điện thoại
  Future<User?> getUserByEmailOrPhone(String email, String phoneNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? OR phoneNumber = ?',
      whereArgs: [email, phoneNumber],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Lấy tất cả người dùng
  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  // Cập nhật thông tin người dùng
  Future<void> updateUser(User user) async {
    if (!user.isValid()) {
      throw Exception('Email or phoneNumber must be provided');
    }

    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Xóa người dùng
  Future<void> deleteUser(String id) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Thêm đơn hàng mới
  Future<void> insertOrder(Order order) async {
    final db = await database;
    await db.insert(
      'orders',
      {
        'id': order.id,
        'customerId': order.customer.id,
        'totalAmount': order.totalAmount,
        'status': order.status,
        'paymentMethod': order.paymentMethod,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Thêm các mục đơn hàng
    for (var item in order.items) {
      await db.insert(
        'order_items',
        {
          'orderId': order.id,
          'productId': item.productId,
          'productName': item.productName,
          'price': item.price,
          'quantity': item.quantity,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Lấy tất cả đơn hàng với thông tin khách hàng và mục đơn hàng
  Future<List<OrderInfoDTO>> getAllOrders() async {
    final db = await database;

    // Lấy tất cả đơn hàng và thông tin khách hàng bằng JOIN
    final List<Map<String, dynamic>> orderMaps = await db.rawQuery('''
      SELECT orders.*, users.name, users.email, users.phoneNumber, users.address
      FROM orders
      INNER JOIN users ON orders.customerId = users.id
    ''');

    final List<OrderInfoDTO> orders = [];

    for (var orderMap in orderMaps) {
      // Lấy các mục đơn hàng từ bảng order_items
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'order_items',
        where: 'orderId = ?',
        whereArgs: [orderMap['id']],
      );

      // Chuyển đổi các mục đơn hàng thành danh sách OrderItem
      final List<OrderItem> items = itemMaps.map((itemMap) {
        return OrderItem(
          productId: itemMap['productId'],
          productName: itemMap['productName'],
          price: itemMap['price'],
          quantity: itemMap['quantity'],
        );
      }).toList();

      // Tạo đối tượng OrderInfoDTO và thêm vào danh sách
      orders.add(OrderInfoDTO.fromMap(orderMap, items));
    }

    return orders;
  }
}