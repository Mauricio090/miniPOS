import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  static final SqliteService instance = SqliteService._init();
  static Database? _database;

  SqliteService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initExistingDB('database.sqlite');
    return _database!;
  }

  Future<Database> _initExistingDB(String dbFileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbFileName);

    final exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join('assets', dbFileName));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(
      path,
      // Se activa el soporte de llaves foráneas en cada apertura de la conexión
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON;');
      },
    );
  }
}