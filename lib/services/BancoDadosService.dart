import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';

class BancoDadosService{
  static final BancoDadosService _instance = BancoDadosService._internal();
  BancoDadosService._internal();
  factory BancoDadosService() => _instance;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('shopping_app.db');
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 5,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE item_compras ADD COLUMN compradoAt INTEGER');
      await db.execute('ALTER TABLE lista_compras ADD COLUMN createdAt INTEGER');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE setores(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        createdAt INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE lista_compras(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        observacao TEXT,
        createdAt INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE item_compras(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        quantidade INTEGER,
        comprado INTEGER DEFAULT 0,
        setorId INTEGER,
        listaId INTEGER,
        compradoAt INTEGER,
        createdAt INTEGER,
        FOREIGN KEY (setorId) REFERENCES setores(id) ON DELETE CASCADE,
        FOREIGN KEY (listaId) REFERENCES lista_compras(id) ON DELETE CASCADE
      );
    ''');
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<int> update(String table, Map<String, dynamic> data, int id) async {
    final db = await database;
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryWhere(
      String table, {
        String? where,
        List<Object?>? whereArgs,
      }) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }
}