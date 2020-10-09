import 'package:uuid/uuid.dart';

import './db.dart';

class Todo {
  String id;
  String title;
  bool isCompleted;
  Todo(this.title, this.isCompleted);
  Todo.fullOptions(this.id, this.title, this.isCompleted);
  Todo.fromMap(Map<String, dynamic> maps) {
    this.id = maps["id"];
    this.title = maps["title"];
    this.isCompleted = maps["isCompleted"] == 1;
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  static Future<List<Todo>> getCompletedTodos() async {
    final db = await DB.getInstance().database;

    final List<Map<String, dynamic>> maps =
        await db.query('TODOS', where: 'isCompleted = 1');

    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  Future<Todo> insert() async {
    final db = await DB.getInstance().database;
    this.id = Uuid().v1();
    var changed = await db.insert("TODOS", this.toMap());
    if (changed == 0) return null;
    return this;
  }

  Future<bool> update() async {
    final db = await DB.getInstance().database;
    var changed = await db
        .update("TODOS", this.toMap(), where: 'id = ?', whereArgs: [this.id]);
    return changed == 1;
  }

  Future<bool> delete() async {
    final db = await DB.getInstance().database;
    var changed =
        await db.delete('TODOS', where: 'id = ?', whereArgs: [this.id]);
    return changed == 1;
  }

  static Future<List<Todo>> getTodos() async {
    final db = await DB.getInstance().database;

    final List<Map<String, dynamic>> maps =
        await db.query('TODOS', where: 'isCompleted = 0');

    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }
}
