import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;

  String studentsTable = 'Students';
  String columnId = 'id';
  String columnName = 'name';

  Future<Database> get database async {
    if (_database != null) return _database as Database;

    _database = await _initDB();
    return _database as Database;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}Student.db';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $studentsTable($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnName TEXT)');
  }
}
