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
    final path = join(dbPath, 'note_database.db');

    return await openDatabase(
      path,
      version: 5,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE notes(id TEXT PRIMARY KEY, userId TEXT, title TEXT, content TEXT, date TEXT, lastUpdated TEXT)",
        );
        await db.execute(
          "CREATE TABLE users(id TEXT PRIMARY KEY, name TEXT, email TEXT, phoneNumber TEXT)",
        );
      },

      // onUpgrade: (db, oldVersion, newVersion) async {
      //   if (oldVersion < 2) {
      //     await db.execute("ALTER TABLE notes ADD COLUMN userId TEXT");
      //   }
      //   if (oldVersion < 4) {
      //     await db.execute(
      //       "CREATE TABLE users(id TEXT PRIMARY KEY, name TEXT, email TEXT, phoneNumber TEXT)",
      //     );
      //   }
      // },
    );
  }
}

Future<void> initDatabaseWithFakeData() async {
  final db = await DBConnection().database;

  await insertFakeUsers(db);
  await insertFakeNotes(db);
}

Future<void> insertFakeUsers(Database db) async {
  await db.insert('users', {
    'id': 'user1',
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'phoneNumber': '123-456-7890'
  });

  await db.insert('users', {
    'id': 'user2',
    'name': 'Jane Smith',
    'email': 'jane.smith@example.com',
    'phoneNumber': '098-765-4321'
  });
}

Future<void> insertFakeNotes(Database db) async {
  await db.insert('notes', {
    'id': 'note1',
    'userId': 'user1',
    'title': 'First Note',
    'content': 'This is the content of the first note.',
    'date': '2024-08-01',
    'lastUpdated': '2024-08-01T10:00:00Z'
  });

  await db.insert('notes', {
    'id': 'note2',
    'userId': 'user1',
    'title': 'Second Note',
    'content': 'This is the content of the second note.',
    'date': '2024-08-02',
    'lastUpdated': '2024-08-02T12:00:00Z'
  });

  await db.insert('notes', {
    'id': 'note3',
    'userId': 'user2',
    'title': 'Third Note',
    'content': 'This is the content of the third note.',
    'date': '2024-08-03',
    'lastUpdated': '2024-08-03T14:00:00Z'
  });
}
