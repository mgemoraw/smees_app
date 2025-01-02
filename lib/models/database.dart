import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite/sqflite.dart';


class SQLHelper {
  static Future<void> createTables(sqlite.Database database) async {
    await database.execute("""
    CREATE TABLE IF NOT EXISTS users(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    userId TEXT,
    university TEXT,
    department TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIME_STAMP,
    
    );
    
    """);
  }

  static Future<sqlite.Database> db() async {
    return sqlite.openDatabase(
      "database.db",
      version: 1,
      onCreate: (sqlite.Database database, int version) async {
        await createTables(database);
      }
    );
  }

  static Future<int> createUser(String? userId, String? university, String? department) async {
    final db = await SQLHelper.db();

    final data = {'userId': userId, 'university': university, 'department': department};
    final id = await db.insert('users', data, conflictAlgorithm: sqlite.ConflictAlgorithm.replace);
    return id;

  }

  // function to retrive users from user table
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await SQLHelper.db();
    return db.query('users', orderBy: 'id');
  }
  
  static Future<List<Map<String, dynamic>>> getUser(int id) async {
    final db = await SQLHelper.db();
    
    return db.query('users', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateUser(String? userId, String? university, String? department) async {
    final db = await SQLHelper.db();

    final data = {
      'userId': userId,
      'university': university,
      'department': department,
    };

    final result = await db.update('users', data, where:"userId = ?", whereArgs: [userId], );

    return result;
  }

  //
}
