import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_task_manager/models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        isDone INTEGER NOT NULL
      )
    ''');
  }

  //CRUD operations

  //Create operation
  Future<int> insertTask(Task task) async {
    final db = await instance.database;
    return await db.insert('tasks', {
      'title': task.title,
      'isDone': task.isDone ? 1 : 0,
    });
  }

  //Read operation
  Future<List<Task>> getAllTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');

    return result
        .map(
          (row) => Task(
            id: row['id'] as int,
            title: row['title'] as String,
            isDone: (row['isDone'] as int) == 1,
          ),
        )
        .toList();
  }

  //Update operation
  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return await db.update(
      'tasks',
      {'title': task.title, 'isDone': task.isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  //Delete operation
  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
