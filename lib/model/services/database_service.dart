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
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final String path = join(await getDatabasesPath(), AppConstants.databaseName);
      if (kDebugMode) print('Initializing database at path: $path');
      return await openDatabase(
        path,
        version: AppConstants.version,
        onCreate: (db, version) async {
          if (kDebugMode) print('Creating table: ${AppConstants.tableName}');
          await db.execute('''
            CREATE TABLE ${AppConstants.tableName} (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              description TEXT,
              dueDate TEXT,
              isCompleted INTEGER NOT NULL,
              lastSyncTime TEXT,
              email TEXT NOT NULL,
              isDeleted INTEGER NOT NULL DEFAULT 0
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            if (kDebugMode) print('Adding isDeleted column');
            await db.execute('ALTER TABLE ${AppConstants.tableName} ADD COLUMN isDeleted INTEGER NOT NULL DEFAULT 0');
          }
        },
      );
    } catch (e) {
      if (kDebugMode) print('Database Error: $e');
      rethrow;
    }
  }

  Future<bool> _tableExists(Database db, String tableName) async {
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    return result.isNotEmpty;
  }

  Future<int> insertTask(TaskEntity task) async {
    try {
      final db = await database;
      if (!(await _tableExists(db, AppConstants.tableName))) {
        if (kDebugMode) print('Table ${AppConstants.tableName} does not exist, recreating...');
        await db.execute('''
          CREATE TABLE ${AppConstants.tableName} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            dueDate TEXT,
            isCompleted INTEGER NOT NULL,
            lastSyncTime TEXT,
            email TEXT NOT NULL,
            isDeleted INTEGER NOT NULL DEFAULT 0
          )
        ''');
      }
      if (kDebugMode) print('Inserting task: ${task.toMap()}');
      return await db.insert(
        AppConstants.tableName,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      if (kDebugMode) print('Database Error: $e');
      rethrow;
    }
  }

  Future<List<TaskEntity>> getTasks() async {
    try {
      final db = await database;
      if (!(await _tableExists(db, AppConstants.tableName))) {
        if (kDebugMode) print('Table ${AppConstants.tableName} does not exist, returning empty list');
        return [];
      }
      final List<Map<String, dynamic>> maps = await db.query(AppConstants.tableName);
      return List.generate(maps.length, (i) => TaskEntity.fromMap(maps[i]));
    } catch (e) {
      if (kDebugMode) print('Database Error: $e');
      rethrow;
    }
  }

  Future<List<TaskEntity>> getTasksByEmail(String email) async {
    try {
      final db = await database;
      if (!(await _tableExists(db, AppConstants.tableName))) {
        if (kDebugMode) print('Table ${AppConstants.tableName} does not exist, returning empty list');
        return [];
      }
      final List<Map<String, dynamic>> maps = await db.query(
        AppConstants.tableName,
        where: 'email = ? AND isDeleted = 0',
        whereArgs: [email],
      );
      return List.generate(maps.length, (i) => TaskEntity.fromMap(maps[i]));
    } catch (e) {
      if (kDebugMode) print('Database Error: $e');
      rethrow;
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    try {
      final db = await database;
      if (!(await _tableExists(db, AppConstants.tableName))) {
        if (kDebugMode) print('Table ${AppConstants.tableName} does not exist, recreating...');
        await db.execute('''
          CREATE TABLE ${AppConstants.tableName} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            dueDate TEXT,
            isCompleted INTEGER NOT NULL,
            lastSyncTime TEXT,
            email TEXT NOT NULL,
            isDeleted INTEGER NOT NULL DEFAULT 0
          )
        ''');
      }
      await db.update(
        AppConstants.tableName,
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    } catch (e) {
      if (kDebugMode) print('Database Error: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final db = await database;
      if (!(await _tableExists(db, AppConstants.tableName))) {
        if (kDebugMode) print('Table ${AppConstants.tableName} does not exist, skipping delete');
        return;
      }
      await db.delete(AppConstants.tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      if (kDebugMode) print('Database Error: $e');
      rethrow;
    }
  }

  Future<void> deleteTasksWhere({required bool isDeleted}) async {
    try {
      final db = await database;
      if (!(await _tableExists(db, AppConstants.tableName))) {
        if (kDebugMode) print('Table ${AppConstants.tableName} does not exist, skipping delete');
        return;
      }
      await db.delete(
        AppConstants.tableName,
        where: 'isDeleted = ?',
        whereArgs: [isDeleted ? 1 : 0],
      );
    } catch (e) {
      if (kDebugMode) print('Database Error: $e');
      rethrow;
    }
  }

  Future<TaskEntity?> getTaskById(int id) async {
    try {
      final db = await database;
      if (!(await _tableExists(db, AppConstants.tableName))) {
        if (kDebugMode) print('Table ${AppConstants.tableName} does not exist, returning null');
        return null;
      }
      final maps = await db.query(
        AppConstants.tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) return TaskEntity.fromMap(maps.first);
      return null;
    } catch (e) {
      if (kDebugMode) print('Database Error: $e');
      rethrow;
    }
  }

  Future<void> close() async {
    try {
      final db = await database;
      await db.close();
      _database = null;
    } catch (e) {
      if (kDebugMode) print('Database Error: $e');
      rethrow;
    }
  }
}