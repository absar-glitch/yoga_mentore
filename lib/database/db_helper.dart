import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    final dbPath = join(await getDatabasesPath(), 'yoga_mentore.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            profile_image TEXT DEFAULT 'assets/images/profile.jpg',
            is_admin INTEGER DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            pose_name TEXT NOT NULL,
            duration_minutes INTEGER NOT NULL,
            accuracy REAL NOT NULL,
            date TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users(id)
          )
        ''');
        // Seed default admin account
        await db.insert('users', {
          'name': 'Admin',
          'email': 'Admin00@gmail.com',
          'password': 'Admin001',
          'is_admin': 1,
        });
      },
    );
  }

  // ── USER OPERATIONS ──────────────────────────────────────────────────────

  /// Register a new user. Throws if email already exists.
  static Future<int> insertUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final db = await database;
    return db.insert(
      'users',
      {'name': name, 'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  /// Returns user map if credentials match, null otherwise.
  static Future<Map<String, dynamic>?> loginUser(
    String email,
    String password,
  ) async {
    final db = await database;
    final rows = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email.trim(), password],
    );
    return rows.isNotEmpty ? Map<String, dynamic>.from(rows.first) : null;
  }

  /// Fetch user by id.
  static Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    final rows = await db.query('users', where: 'id = ?', whereArgs: [id]);
    return rows.isNotEmpty ? Map<String, dynamic>.from(rows.first) : null;
  }

  /// Fetch user by email.
  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final rows = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim()],
    );
    return rows.isNotEmpty ? Map<String, dynamic>.from(rows.first) : null;
  }

  /// Update any user fields by id.
  static Future<void> updateUser(int id, Map<String, dynamic> data) async {
    final db = await database;
    await db.update('users', data, where: 'id = ?', whereArgs: [id]);
  }

  /// Get all non-admin users (for admin panel).
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return db.query('users', where: 'is_admin = 0', orderBy: 'name ASC');
  }

  /// Delete a user by id.
  static Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
    await db.delete('sessions', where: 'user_id = ?', whereArgs: [id]);
  }

  // ── SESSION OPERATIONS ───────────────────────────────────────────────────

  /// Save a completed yoga session.
  static Future<int> insertSession({
    required int userId,
    required String poseName,
    required int durationMinutes,
    required double accuracy,
  }) async {
    final db = await database;
    return db.insert('sessions', {
      'user_id': userId,
      'pose_name': poseName,
      'duration_minutes': durationMinutes,
      'accuracy': accuracy,
      'date': DateTime.now().toIso8601String(),
    });
  }

  /// Get all sessions for a user, newest first.
  static Future<List<Map<String, dynamic>>> getUserSessions(int userId) async {
    final db = await database;
    final rows = await db.query(
      'sessions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return rows.map((r) => Map<String, dynamic>.from(r)).toList();
  }

  /// Aggregate stats for a user.
  static Future<Map<String, dynamic>> getUserStats(int userId) async {
    final sessions = await getUserSessions(userId);
    final totalMinutes = sessions.fold<int>(
      0,
      (sum, s) => sum + (s['duration_minutes'] as int),
    );
    final avgAccuracy = sessions.isEmpty
        ? 0.0
        : sessions.fold<double>(
              0,
              (sum, s) => sum + (s['accuracy'] as double),
            ) /
            sessions.length;
    return {
      'total_sessions': sessions.length,
      'total_minutes': totalMinutes,
      'avg_accuracy': avgAccuracy,
    };
  }
}
