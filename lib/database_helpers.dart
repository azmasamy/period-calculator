import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'period.dart';

// database table and column names
final String table = 'period';
final String columnId = '_id';
final String columnDate = 'date';
final String columnDuration = 'duration';

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase.db";

  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print(documentsDirectory.path);
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $table (
                $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
                $columnDate TEXT NOT NULL,
                $columnDuration INTEGER
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(Period period) async {
    Database db = await database;
    int id = await db.insert(table, period.toMap());
    return id;
  }

  Future<List<Period>> queryPeriods() async {
    Database db = await database;
    List<Map> maps =
        await db.query(table, columns: [columnId, columnDate, columnDuration]);
    List<Period> periods = [];
    if (maps.length > 0) {
      maps.forEach((map) {
        periods.add(Period.fromMap(map));
      });
    }
    return periods;
  }

  Future<int> delete(int id) async {
    Database db = await database;
    int deletedId = await db.delete(table,
    where: '$columnId = ?',
    whereArgs: [id]);
    return deletedId;
  }

  Future<int> update(Period period) async {
    Database db = await database;
    int updatedId = await db.update(table, period.toMap(),
        where: '$columnId = ?', whereArgs: [period.id]);
    return updatedId;
  }
}
