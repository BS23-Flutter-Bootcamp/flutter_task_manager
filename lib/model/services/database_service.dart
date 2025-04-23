import 'package:flutter/foundation.dart';
import 'package:flutter_task_manager/constants/app_constants.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

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
      final String path = join(
        await getDatabasesPath(),
        AppConstants.databaseName,
      );
      return await openDatabase(
        path,
        version: AppConstants.version + 1, // Increment version for migration
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE ${AppConstants.tableName} (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              description TEXT,
              dueDate TEXT,
              isCompleted INTEGER NOT NULL,
              lastSyncTime TEXT,
              email TEXT NOT NULL
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            // Add lastSyncTime and email columns
            await db.execute('ALTER TABLE ${AppConstants.tableName} ADD COLUMN lastSyncTime TEXT');
            await db.execute('ALTER TABLE ${AppConstants.tableName} ADD COLUMN email TEXT NOT NULL DEFAULT ""');
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Database Error: $e');
      }
      rethrow;
    }
  }

  Future<void> insertTask(TaskEntity task) async {
    try {
      final db = await database;
      await db.insert(
        AppConstants.tableName,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Database Error: $e');
      }
      rethrow;
    }
  }

  Future<List<TaskEntity>> getTasks() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.tableName,
      );
      return List.generate(maps.length, (i) => TaskEntity.fromMap(maps[i]));
    } catch (e) {
      if (kDebugMode) {
        print('Database Error: $e');
      }
      rethrow;
    }
  }

  Future<List<TaskEntity>> getTasksByEmail(String email) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.tableName,
        where: 'email = ?',
        whereArgs: [email],
      );
      return List.generate(maps.length, (i) => TaskEntity.fromMap(maps[i]));
    } catch (e) {
      if (kDebugMode) {
        print('Database Error: $e');
      }
      rethrow;
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    try {
      final db = await database;
      await db.update(
        AppConstants.tableName,
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Database Error: $e');
      }
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final db = await database;
      await db.delete(AppConstants.tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      if (kDebugMode) {
        print('Database Error: $e');
      }
      rethrow;
    }
  }

  Future<void> close() async {
    try {
      final db = await database;
      await db.close();
      _database = null;
    } catch (e) {
      if (kDebugMode) {
        print('Database Error: $e');
      }
      rethrow;
    }
  }
}