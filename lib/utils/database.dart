import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/user.dart';

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
    String path = join(await getDatabasesPath(), 'Users_database.db');
    return await openDatabase(
      path,
      version: 2, // Incremented version to force re-creation
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        profile TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('DROP TABLE IF EXISTS Users');
      await _onCreate(db, newVersion);
    }
  }

  // Insert a User into the database
  Future<int> insertUser(User user) async {
    Database db = await database;
    return await db.insert('Users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Retrieve all Users from the database
  Future<List<User>> getUsers() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  // Update a User in the database
  Future<int> updateUser(User user) async {
    Database db = await database;
    return await db.update(
      'Users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Delete a User from the database
  Future<void> deleteUser(int id) async {
    Database db = await database;
    await db.delete(
      'Users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}