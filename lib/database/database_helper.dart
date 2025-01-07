import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../dto/order_info_dto.dart';
import '../models/user.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/board_game.dart';
import '../models/category.dart';
import '../models/brand.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'boardgames.db');

    // Kiểm tra xem database đã tồn tại chưa
    if (!await File(path).exists()) {
      // Copy database từ assets vào thư mục ứng dụng
      ByteData data = await rootBundle.load('assets/boardgames.db');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

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
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
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

// Thêm boardgame mới
  Future<void> insertBoardGame(BoardGame boardGame) async {
    final db = await database;
    await db.insert(
      'boardgames',
      boardGame.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
// Lấy tất cả boardgames
Future<List<BoardGame>> getAllBoardGames() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('boardgames');

  return List.generate(maps.length, (i) {
    return BoardGame.fromMap(maps[i]);
  });
}
  Future<void> updateBoardGame(BoardGame boardGame) async {
    final db = await database;
    await db.update(
      'boardgames',
      boardGame.toMap(),
      where: 'id = ?',
      whereArgs: [boardGame.id],
    );
  }

//Thêm category mới
  Future<void> insertCategory(Category category) async {
    final db = await database;
    await db.insert(
      'categories',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
//
// //Lấy tất cả categories
Future<List<Category>> getAllCategories() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('categories');

  return List.generate(maps.length, (i) {
    return Category.fromMap(maps[i]);
  });
}
//
// //Thêm brand mới
Future<void> insertBrand(Brand brand) async {
  final db = await database;
  await db.insert(
    'brands',
    brand.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
//
//Lấy tất cả brands
Future<List<Brand>> getAllBrands() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('brands');

  return List.generate(maps.length, (i) {
    return Brand.fromMap(maps[i]);
  });
}
  Future<void> deleteBoardGame(String id) async {
    final db = await database;
    await db.delete(
      'boardgames',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}