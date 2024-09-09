import 'package:sqflite/sqflite.dart';
// To get the path of the database
import 'package:path/path.dart';

import '../Model/Task.dart';

class DbHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "Tasks";

  // Connect to the database
  static Future<void> init() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = join(await getDatabasesPath(), 'tasks.db');
      _db =
          await openDatabase(_path, version: _version, onCreate: (db, version) {
        print("Creating a new Database");
        return db.execute(
            "CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, date TEXT, startTime TEXT, endTime TEXT, remind INTEGER, repeat TEXT, color INTEGER, isCompleted INTEGER)");
      });
    } catch (e) {
      print(e);
    }
  }

  // Insert data to db
  static Future<int> insert(Task? task) async {
    if (_db == null) {
      throw Exception("Database not initialized");
    }
    if (task == null) {
      throw ArgumentError("Task cannot be null");
    }
    print('Insert function called');
    return await _db!.insert(_tableName, task.toJson());
  }

  // Retrieve data from db
  static Future<List<Map<String, dynamic>>> query() async {
    print('Query function called');
    return await _db!.query(_tableName);
  }

  // Delete the task
  static delete(Task task) async {
    await _db!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  // Update the task status to completed
  static updateTaskStatus(int id) async {
    print('status changed called $id');
    return await _db!
        .rawUpdate('UPDATE Tasks SET isCompleted = ? WHERE id = ?', [1, id]);
  }

  // Update the task status to completed
  static updateTaskStatusIncomplete(int id) async {
    return await _db!
        .rawUpdate('UPDATE Tasks SET isCompleted = ? WHERE id = ?', [0, id]);
  }

  // Update the task data
  static Future<int> update(Task task) async {
    if (_db == null) {
      throw Exception("Database not initialized");
    }
    if (task.id == null) {
      throw ArgumentError("Task ID cannot be null");
    }
    print('Update function called');
    return await _db!.update(
      _tableName,
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}
