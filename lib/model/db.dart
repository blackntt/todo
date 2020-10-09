import 'dart:async';

import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class DB {
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    String dbPath = join(await getDatabasesPath(), 'todo.db');
    _database = await openDatabase(
      dbPath,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE TODOS(id TEXT PRIMARY KEY, title TEXT, isCompleted INTEGER)",
        );
      },
      version: 1,
    );
    return _database;
  }

  DB._();
  static final DB db = DB._();
  static DB getInstance() {
    return db;
  }
}
