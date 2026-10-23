import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/course/data/models/course_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    try {
      _database = await _initDB('uniquiz_pro.db');
    } catch (e, st) {
      debugPrint('DATABASE INIT ERROR: $e\n$st');
      rethrow;
    }
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onOpen: (db) async {
        // Ensure tables exist even if database file already existed
        await _createTables(db);
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await _createTables(db);
    await _seedInitialData(db);
  }

  Future _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        studentId TEXT NOT NULL,
        department TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS courses(
        id TEXT PRIMARY KEY,
        code TEXT NOT NULL,
        title TEXT NOT NULL,
        instructor TEXT NOT NULL,
        department TEXT NOT NULL,
        enrolledStudents INTEGER NOT NULL,
        progress REAL NOT NULL
      )
    ''');
  }

  Future _seedInitialData(Database db) async {
    // Check if users table is empty before seeding
    final userCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM users'));
    if (userCount == 0) {
      // Seed default student
      await db.insert('users', {
        'id': 'u_001',
        'name': 'Alex Johnson',
        'email': 'alex.student@university.edu',
        'studentId': 'CSE-2023-045',
        'department': 'Computer Science & Engineering',
        'role': 'student',
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      // Seed default faculty
      await db.insert('users', {
        'id': 'u_002',
        'name': 'Dr. Alan Turing',
        'email': 'alan.turing@university.edu',
        'studentId': 'FAC-CSE-01',
        'department': 'Computer Science & Engineering',
        'role': 'faculty',
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // Check if courses table is empty before seeding
    final courseCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM courses'));
    if (courseCount == 0) {
      for (var course in CourseModel.mockCourses) {
        await db.insert('courses', course.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  // User Queries
  Future<UserModel?> getUserByEmail(String email) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    }
    return null;
  }

  Future<void> insertUser(UserModel user) async {
    final db = await instance.database;
    await db.insert(
      'users',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Course Queries
  Future<List<CourseModel>> getCourses() async {
    final db = await instance.database;
    final result = await db.query('courses');
    return result.map((json) => CourseModel.fromJson(json)).toList();
  }

  Future<CourseModel?> getCourseById(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CourseModel.fromJson(maps.first);
    }
    return null;
  }
}
