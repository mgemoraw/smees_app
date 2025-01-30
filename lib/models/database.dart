import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:smees/models/test_model.dart';
import 'package:smees/models/user.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



Future<String> getDocumentsPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return join(directory.path, "smees.db");
}

class SmeesHelper {
  static final SmeesHelper _instance  = SmeesHelper._internal();
  factory SmeesHelper() => _instance;

  SmeesHelper._internal();

  Database? _database;
  

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path;
    if (Platform.isWindows){
      path = await getDocumentsPath();
    }else {
      path = join(await getDatabasesPath(), "smees.db");
    }
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE users(
            userId TEXT PRIMARY KEY, 
            username TEXT,
            email TEXT,
            fullName TEXT,
            department TEXT,
            university TEXT
          )
          '''
        );
        await db.execute(
          '''
          CREATE TABLE tests(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            userId TEXT, 
            testStarted TIMESTAMP,
            testEnded TIMESTAMP DEFAULT CURRENT_TIME_STAMP, 
            questions INTEGER,
            score DOUBLE)
          '''
        );
        await db.execute(
          '''
          CREATE TABLE exams(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            userId VARCHAR(30), 
            examStarted TIMESTAMP,
            examEnded TIMESTAMP DEFAULT CURRENT_TIME_STAMP,
            questions INTEGER,
            score DOUBLE
          )
          '''
        );
      }
    );
  }

  Future <void> addUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert(
      'users', 
      user, 
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future <void> updateUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.update(
      'users',
      user,
      where: 'userId= ?', 
      whereArgs: [user['userId']],
    );
  }

   Future <void> deleteUser(String userId) async {
    final db = await database;
    await db.delete(
      'users', 
      where: 'userId= ?', 
      whereArgs: [userId],
    );
  }

  Future <List<Map<String, dynamic>>> fetchAllUsers() async {
    final db = await database;
    return await db.query(
      'users',
      );
  }

  Future <Map<String, dynamic>?> fetchUser(String userId) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'userId= ?',
      whereArgs: [userId],
      );
    
    if (result.isNotEmpty){
      return result.first;
    }
    return null;
  }

  Future <void> addTest(Map<String, dynamic> test) async {
    final db = await database;
    await db.insert(
      'tests', 
      test, 
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

   Future <void> deleteTest(int testId) async {
    final db = await database;
    await db.delete(
      'tests', 
      where: 'id= ?', 
      whereArgs: [testId],
    );
  }

  Future <List<Map<String, dynamic>>> getTests() async {
    final db = await database;
    return await db.query('tests');
  }

  Future <void> addExam(Map<String, dynamic> exam) async {
    final db = await database;
    await db.insert(
      'tests', 
      exam, 
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

   Future <void> deleteExam(int examId) async {
    final db = await database;
    await db.delete(
      'exams', 
      where: 'id= ?', 
      whereArgs: [examId],
    );
  }

  
  Future <List<Map<String, dynamic>>> getExams() async {
    final db = await database;
    return await db.query('exams');
  }

}



class SQLHelper {
  static final SQLHelper _instance  = SQLHelper._internal();
  factory SQLHelper() => _instance;

  SQLHelper._internal();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database;
  }

  static Future<Database?> _initDatabase() async {
    String path = join(await getDatabasesPath(), "smees.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE users(
            id, INTEGER PRIMARY KEY AUTOINCREMENT, 
            userId TEXT, 
            username TEXT,
            department TEXT,
            university TEXT,
          )
          '''
        );
        await db.execute(
          '''
          CREATE TABLE tests(
            id, INTEGER PRIMARY KEY AUTOINCREMENT, 
            userId TEXT, 
            testStarted TIMESTAMP,
            testEnded TIMESTAMP DEFAULT CURRENT_TIME_STAMP, 
            questions INTEGER,
            score DOUBLE)
          '''
        );
        await db.execute(
          '''
          CREATE TABLE exams(
            id, INTEGER PRIMARY KEY AUTOINCREMENT, 
            userId VARCHAR(30), 
            examStarted TIMESTAMP,
            examEnded TIMESTAMP DEFAULT CURRENT_TIME_STAMP,
            questions INTEGER,
            score DOUBLE,
          )
          '''
        );
      }
    );
  }

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
      "smees.db",
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
