import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tasknest/models/task_model.dart';
import 'package:tasknest/models/habit_model.dart';

class DatabaseService extends ChangeNotifier {
  static Database? _database;
  static const String _databaseName = 'tasknest.db';
  static const int _databaseVersion = 1;

  // Tables
  static const String tasksTable = 'tasks';
  static const String habitsTable = 'habits';

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    // Tasks table
    await db.execute('''
      CREATE TABLE $tasksTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        dueDate TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        category TEXT NOT NULL,
        tags TEXT,
        priority TEXT NOT NULL,
        colorCode TEXT NOT NULL,
        hasReminder INTEGER NOT NULL DEFAULT 0,
        reminderDate TEXT,
        isRepeating INTEGER NOT NULL DEFAULT 0,
        repeatFrequency TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Habits table
    await db.execute('''
      CREATE TABLE $habitsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        targetFrequency INTEGER NOT NULL,
        currentStreak INTEGER NOT NULL,
        longestStreak INTEGER NOT NULL,
        completedCount INTEGER NOT NULL,
        weeklyCompletion TEXT NOT NULL,
        category TEXT NOT NULL,
        colorCode TEXT NOT NULL,
        hasReminder INTEGER NOT NULL DEFAULT 0,
        reminderTime TEXT,
        startDate TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  // Initialize service
  Future<void> init() async {
    await database;
    notifyListeners();
  }

  // CRUD Operations for Tasks

  // Create a new task
  Future<int> insertTask(Task task) async {
    final db = await database;
    final id = await db.insert(tasksTable, task.toMap());
    notifyListeners();
    return id;
  }

  // Get all tasks
  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tasksTable,
      orderBy: 'dueDate ASC',
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  // Get tasks by category
  Future<List<Task>> getTasksByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tasksTable,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'dueDate ASC',
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  // Get completed tasks
  Future<List<Task>> getCompletedTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tasksTable,
      where: 'isCompleted = ?',
      whereArgs: [1],
      orderBy: 'updatedAt DESC',
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  // Get pending tasks
  Future<List<Task>> getPendingTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tasksTable,
      where: 'isCompleted = ?',
      whereArgs: [0],
      orderBy: 'dueDate ASC',
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  // Update a task
  Future<int> updateTask(Task task) async {
    final db = await database;
    final result = await db.update(
      tasksTable,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    notifyListeners();
    return result;
  }

  // Delete a task
  Future<int> deleteTask(int id) async {
    final db = await database;
    final result = await db.delete(
      tasksTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
    return result;
  }

  // CRUD Operations for Habits

  // Create a new habit
  Future<int> insertHabit(Habit habit) async {
    final db = await database;
    final id = await db.insert(habitsTable, habit.toMap());
    notifyListeners();
    return id;
  }

  // Get all habits
  Future<List<Habit>> getAllHabits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(habitsTable);
    return List.generate(maps.length, (i) => Habit.fromMap(maps[i]));
  }

  // Get habits by category
  Future<List<Habit>> getHabitsByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      habitsTable,
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) => Habit.fromMap(maps[i]));
  }

  // Update a habit
  Future<int> updateHabit(Habit habit) async {
    final db = await database;
    final result = await db.update(
      habitsTable,
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
    notifyListeners();
    return result;
  }

  // Delete a habit
  Future<int> deleteHabit(int id) async {
    final db = await database;
    final result = await db.delete(
      habitsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
    return result;
  }

  // Get today's tasks
  Future<List<Task>> getTodaysTasks() async {
    final db = await database;
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final List<Map<String, dynamic>> maps = await db.query(
      tasksTable,
      where: 'dueDate BETWEEN ? AND ? AND isCompleted = ?',
      whereArgs: [todayStart.toIso8601String(), todayEnd.toIso8601String(), 0],
      orderBy: 'dueDate ASC',
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  // Get overdue tasks
  Future<List<Task>> getOverdueTasks() async {
    final db = await database;
    final now = DateTime.now();

    final List<Map<String, dynamic>> maps = await db.query(
      tasksTable,
      where: 'dueDate < ? AND isCompleted = ?',
      whereArgs: [now.toIso8601String(), 0],
      orderBy: 'dueDate ASC',
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
