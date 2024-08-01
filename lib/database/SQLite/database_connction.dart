import 'package:notex/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBConnection {
  static final DBConnection _instance = DBConnection._internal();
  factory DBConnection() => _instance;

  DBConnection._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'note_data.db');

    return await openDatabase(
      path,
      version: 66,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE notes(id TEXT PRIMARY KEY, userId TEXT, title TEXT, content TEXT, date TEXT, lastUpdated TEXT)",
        );
        await db.execute(
          "CREATE TABLE users(id TEXT PRIMARY KEY, name TEXT, email TEXT, phoneNumber TEXT)",
        );
      },
    );
  }

}

