import 'package:flutter/foundation.dart' hide Category;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tasknest/models/task_model.dart';
import 'package:tasknest/models/habit_model.dart';
import 'package:tasknest/models/category_model.dart';

class DatabaseService extends ChangeNotifier {
  static Database? _database;
  static const String _dbName = 'tasknest.db';
  static const int _dbVersion = 1;

  static const String tableTasks = 'tasks';
  static const String tableHabits = 'habits';
  static const String tableCategories = 'categories';

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> initialize() async {
    if (!_isInitialized) {
      await database;
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        dueDate INTEGER NOT NULL,
        isCompleted INTEGER DEFAULT 0,
        category TEXT,
        priority TEXT,
        tags TEXT,
        colorCode TEXT,
        reminderId INTEGER DEFAULT -1,
        hasReminder INTEGER DEFAULT 0,
        completedAt INTEGER,
        createdAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableHabits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        targetFrequency INTEGER NOT NULL,
        currentStreak INTEGER DEFAULT 0,
        completedCount INTEGER DEFAULT 0,
        completionDays TEXT,
        category TEXT,
        colorCode TEXT,
        startDate INTEGER NOT NULL,
        lastCompleted INTEGER,
        reminderId INTEGER DEFAULT -1,
        hasReminder INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableCategories (
        name TEXT PRIMARY KEY,
        colorCode TEXT NOT NULL,
        icon TEXT NOT NULL,
        taskCount INTEGER DEFAULT 0,
        habitCount INTEGER DEFAULT 0
      )
    ''');

    for (final category in Categories.defaultCategories) {
      await db.insert(tableCategories, category.toMap());
    }
  }

  // Task operations
  Future<int> insertTask(Task task) async {
    final db = await database;
    final id = await db.insert(tableTasks, task.toMap());
    notifyListeners();
    return id;
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableTasks);
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<List<Task>> getTasksByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableTasks,
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    final result = await db.update(
      tableTasks,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    notifyListeners();
    return result;
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    final result = await db.delete(
      tableTasks,
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
    return result;
  }

  // Habit operations
  Future<int> insertHabit(Habit habit) async {
    final db = await database;
    final id = await db.insert(tableHabits, habit.toMap());
    notifyListeners();
    return id;
  }

  Future<List<Habit>> getAllHabits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableHabits);
    return List.generate(maps.length, (i) => Habit.fromMap(maps[i]));
  }

  Future<int> updateHabit(Habit habit) async {
    final db = await database;
    final result = await db.update(
      tableHabits,
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
    notifyListeners();
    return result;
  }

  Future<int> deleteHabit(int id) async {
    final db = await database;
    final result = await db.delete(
      tableHabits,
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
    return result;
  }

  // Category operations
  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableCategories);
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  Future<int> updateCategory(Category category) async {
    final db = await database;
    final result = await db.update(
      tableCategories,
      category.toMap(),
      where: 'name = ?',
      whereArgs: [category.name],
    );
    notifyListeners();
    return result;
  }

  // Statistics methods
  Future<int> getCompletedTasksCount() async {
    final db = await database;
    final result = await db
        .rawQuery('SELECT COUNT(*) FROM $tableTasks WHERE isCompleted = 1');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getTotalTasksCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM $tableTasks');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Map<String, int>> getTasksByDay() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT date(dueDate / 1000, 'unixepoch') as day, COUNT(*) as count 
      FROM $tableTasks 
      WHERE isCompleted = 1 
      GROUP BY day
    ''');

    final Map<String, int> tasksByDay = {};
    for (final map in result) {
      tasksByDay[map['day'].toString()] = map['count'] as int;
    }
    return tasksByDay;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
    _isInitialized = false;
    notifyListeners();
  }
}
