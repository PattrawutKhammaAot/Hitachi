import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  final String tableName = 'my_table';
  final String columnId = '_id';
  final String columnName = 'name';
  final String columnAge = 'age';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'my_database.db');
    var database = await openDatabase(dbPath, version: 1, onCreate: _createDb);

    if (await database.isOpen) {
      print('Database is open');
    } else {
      print('Database is closed');
    }
    //print(databasesPath);
    return database;
  }
  //สร้างไฟล์กับ Column

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnName TEXT, $columnAge INTEGER)');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await this.database;
    return await db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await this.database;
    return await db.query(tableName);
  }

  //เขียนข้อมูลในSQlite
  Future<void> writeDataToSQLite(String name, int age) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'name': name,
        'age': age,
      };
      int id = await db.insert('my_table', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
  }

  //ลบข้อมูลในSQLITE
  Future<void> deleteDataFromSQLite(int id) async {
    try {
      Database db = await DatabaseHelper().database;
      int count =
          await db.delete('my_table', where: '_id = ?', whereArgs: [id]);
      print('Data deleted from SQLite with count: $count');
    } catch (e) {
      print('Error deleting from SQLite: $e');
    }
  }

  // Future<void> findSqliteFile() async {
  //   Directory appDocDir = await getApplicationDocumentsDirectory();
  //   String sqliteFilePath = '${appDocDir.path}/my_database.db';
  //   print(sqliteFilePath);
  //   // ตรวจสอบว่าไฟล์มีอยู่จริงหรือไม่
  //   if (await File(sqliteFilePath).exists()) {
  //     print('Found SQLite file at $sqliteFilePath');
  //   } else {
  //     print('SQLite file not found!');
  //   }
  // }
}
