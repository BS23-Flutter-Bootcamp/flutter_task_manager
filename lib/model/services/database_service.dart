import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'tasks.db';
  static const String _tableName = 'tasks';
  static const int _version = 1;

  factory DatabaseService() => _instance;
  static final DatabaseService _instance = DatabaseService._internal();
  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final String path = join(await getDatabasesPath(), _databaseName);
      return await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $_tableName (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              description TEXT,
              dueDate TEXT,
              isCompleted INTEGER NOT NULL
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute('DROP TABLE IF EXISTS $_tableName');
            await db.execute('''
              CREATE TABLE $_tableName (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                description TEXT,
                dueDate TEXT,
                isCompleted INTEGER NOT NULL
              )
            ''');
          }
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> insertTask(TaskEntity task) async {
    try {
      final db = await database;
      await db.insert(_tableName, task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TaskEntity>> getTasks() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(_tableName);
      return List.generate(maps.length, (i) => TaskEntity.fromMap(maps[i]));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    try {
      final db = await database;
      await db.update(
        _tableName,
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final db = await database;
      await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> close() async {
    try {
      final db = await database;
      await db.close();
      _database = null;
    } catch (e) {
      rethrow;
    }
  }
}