import 'package:sqflite/sqflite.dart';
import 'database_service.dart';

//Modelo base
abstract class BaseModel {
  final int? id;
  BaseModel({this.id}); 
  Map<String, dynamic> toMap();
}

class GenericRepository<T extends BaseModel> {
  final String tableName;
  final T Function(Map<String, dynamic> map) fromMap;

  GenericRepository({
    required this.tableName,
    required this.fromMap,
  });

  // 1. CREAR (Insert)
  Future<int> insert(T item) async {
    final db = await SqliteService.instance.database;
    // conflictAlgorithm.replace actualiza si el registro ya existe por su Primary Key
    return await db.insert(
      tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 2. LEER TODOS (Select All)
  Future<List<T>> getAll({String? orderBy}) async {
    final db = await SqliteService.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: orderBy,
    );
    return List.generate(maps.length, (i) => fromMap(maps[i]));
  }

  // 3. LEER POR ID (Select by ID)
  Future<T?> getById(int id) async {
    final db = await SqliteService.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return fromMap(maps.first);
    }
    return null;
  }

  // 4. ACTUALIZAR (Update)
  Future<int> update(T item) async {
    final db = await SqliteService.instance.database;
    return await db.update(
      tableName,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  // 5. ELIMINAR (Delete)
  Future<int> delete(int id) async {
    final db = await SqliteService.instance.database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}