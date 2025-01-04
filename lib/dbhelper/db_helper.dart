import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:project_boardgames_flutter/models/cart.dart';
import 'package:project_boardgames_flutter/models/cart_item.dart';
import 'package:project_boardgames_flutter/models/category.dart';
import 'package:project_boardgames_flutter/models/manufacturer.dart';
import 'package:project_boardgames_flutter/models/order.dart';
import 'package:project_boardgames_flutter/models/order_item.dart';
import 'package:project_boardgames_flutter/models/product.dart';
import 'package:project_boardgames_flutter/models/user.dart';
import 'package:project_boardgames_flutter/models/role.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Cart(
        id INTEGER PRIMARY KEY,
        customerName TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE CartItem(
        id INTEGER PRIMARY KEY,
        productName TEXT,
        imageUrl TEXT,
        price REAL,
        quantity INTEGER,
        cartId INTEGER,
        FOREIGN KEY(cartId) REFERENCES Cart(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Category(
        id INTEGER PRIMARY KEY,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Manufacturer(
        id INTEGER PRIMARY KEY,
        name TEXT,
        address TEXT,
        phoneNumber TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Product(
        id INTEGER PRIMARY KEY,
        name TEXT,
        price REAL,
        manufacturerId INTEGER,
        categoryId INTEGER,
        FOREIGN KEY(manufacturerId) REFERENCES Manufacturer(id),
        FOREIGN KEY(categoryId) REFERENCES Category(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE User(
        id INTEGER PRIMARY KEY,
        name TEXT,
        username TEXT,
        password TEXT,
        email TEXT,
        phoneNumber TEXT,
        address TEXT,
        role TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Order(
        id INTEGER PRIMARY KEY,
        recipientName TEXT,
        deliveryAddress TEXT,
        totalPrice REAL,
        customerId INTEGER,
        FOREIGN KEY(customerId) REFERENCES User(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE OrderItem(
        id INTEGER PRIMARY KEY,
        productId INTEGER,
        quantity INTEGER,
        orderId INTEGER,
        FOREIGN KEY(productId) REFERENCES Product(id),
        FOREIGN KEY(orderId) REFERENCES Order(id)
      )
    ''');
  }

  // Cart methods
  Future<int> insertCart(Cart cart) async {
    Database db = await database;
    return await db.insert('Cart', cart.toJson());
  }

  Future<List<Cart>> getCarts() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('Cart');
    return List.generate(maps.length, (i) {
      return Cart.fromJson(maps[i]);
    });
  }

  Future<int> updateCart(Cart cart) async {
    Database db = await database;
    return await db.update('Cart', cart.toJson(), where: 'id = ?', whereArgs: [cart.id]);
  }

  Future<int> deleteCart(int id) async {
    Database db = await database;
    return await db.delete('Cart', where: 'id = ?', whereArgs: [id]);
  }

  // CartItem methods
  Future<int> insertCartItem(CartItem cartItem, int cartId) async {
    Database db = await database;
    Map<String, dynamic> itemMap = cartItem.toJson();
    itemMap['cartId'] = cartId;
    return await db.insert('CartItem', itemMap);
  }

  Future<List<CartItem>> getCartItems(int cartId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('CartItem', where: 'cartId = ?', whereArgs: [cartId]);
    return List.generate(maps.length, (i) {
      return CartItem.fromJson(maps[i]);
    });
  }

  Future<int> updateCartItem(CartItem cartItem) async {
    Database db = await database;
    return await db.update('CartItem', cartItem.toJson(), where: 'id = ?', whereArgs: [cartItem]);
  }

  Future<int> deleteCartItem(int id) async {
    Database db = await database;
    return await db.delete('CartItem', where: 'id = ?', whereArgs: [id]);
  }

  // Category methods
  Future<int> insertCategory(Category category) async {
    Database db = await database;
    return await db.insert('Category', category.toJson());
  }

  Future<List<Category>> getCategories() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('Category');
    return List.generate(maps.length, (i) {
      return Category.fromJson(maps[i]);
    });
  }

  Future<int> updateCategory(Category category) async {
    Database db = await database;
    return await db.update('Category', category.toJson(), where: 'id = ?', whereArgs: [category.id]);
  }

  Future<int> deleteCategory(int id) async {
    Database db = await database;
    return await db.delete('Category', where: 'id = ?', whereArgs: [id]);
  }

  // Manufacturer methods
  Future<int> insertManufacturer(Manufacturer manufacturer) async {
    Database db = await database;
    return await db.insert('Manufacturer', manufacturer.toJson());
  }

  Future<List<Manufacturer>> getManufacturers() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('Manufacturer');
    return List.generate(maps.length, (i) {
      return Manufacturer.fromJson(maps[i]);
    });
  }

  Future<int> updateManufacturer(Manufacturer manufacturer) async {
    Database db = await database;
    return await db.update('Manufacturer', manufacturer.toJson(), where: 'id = ?', whereArgs: [manufacturer.id]);
  }

  Future<int> deleteManufacturer(int id) async {
    Database db = await database;
    return await db.delete('Manufacturer', where: 'id = ?', whereArgs: [id]);
  }

  // Product methods
  Future<int> insertProduct(Product product) async {
    Database db = await database;
    return await db.insert('Product', product.toJson());
  }

  Future<List<Product>> getProducts() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('Product');
    return List.generate(maps.length, (i) {
      return Product.fromJson(maps[i]);
    });
  }

  Future<int> updateProduct(Product product) async {
    Database db = await database;
    return await db.update('Product', product.toJson(), where: 'id = ?', whereArgs: [product.id]);
  }

  Future<int> deleteProduct(int id) async {
    Database db = await database;
    return await db.delete('Product', where: 'id = ?', whereArgs: [id]);
  }

  // User methods
  Future<int> insertUser(User user) async {
    Database db = await database;
    return await db.insert('User', user.toJson());
  }

  Future<List<User>> getUsers() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('User');
    return List.generate(maps.length, (i) {
      return User.fromJson(maps[i]);
    });
  }

  Future<int> updateUser(User user) async {
    Database db = await database;
    return await db.update('User', user.toJson(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete('User', where: 'id = ?', whereArgs: [id]);
  }

  // Order methods
  Future<int> insertOrder(Order order) async {
    Database db = await database;
    return await db.insert('Order', order.toJson());
  }

  Future<List<Order>> getOrders() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('Order');
    return List.generate(maps.length, (i) {
      return Order.fromJson(maps[i]);
    });
  }

  Future<int> updateOrder(Order order) async {
    Database db = await database;
    return await db.update('Order', order.toJson(), where: 'id = ?', whereArgs: [order.id]);
  }

  Future<int> deleteOrder(int id) async {
    Database db = await database;
    return await db.delete('Order', where: 'id = ?', whereArgs: [id]);
  }

  // OrderItem methods
  Future<int> insertOrderItem(OrderItem orderItem, int orderId) async {
    Database db = await database;
    Map<String, dynamic> itemMap = orderItem.toJson();
    itemMap['orderId'] = orderId;
    return await db.insert('OrderItem', itemMap);
  }

  Future<List<OrderItem>> getOrderItems(int orderId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('OrderItem', where: 'orderId = ?', whereArgs: [orderId]);
    return List.generate(maps.length, (i) {
      return OrderItem.fromJson(maps[i]);
    });
  }

  Future<int> updateOrderItem(OrderItem orderItem) async {
    Database db = await database;
    return await db.update('OrderItem', orderItem.toJson(), where: 'id = ?', whereArgs: [orderItem.id]);
  }

  Future<int> deleteOrderItem(int id) async {
    Database db = await database;
    return await db.delete('OrderItem', where: 'id = ?', whereArgs: [id]);
  }
}