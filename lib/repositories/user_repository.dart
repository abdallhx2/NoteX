
import 'package:notex/database/SQLite/database_connction.dart';
import 'package:notex/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository {
  final dbConnection = DBConnection();

  Future<void> addUser(UserModels user) async {
    final db = await dbConnection.database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModels?> getUserById(String id) async {
    final db = await dbConnection.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserModels.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<UserModels?> getUserByEmail(String email) async {
    final db = await dbConnection.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: "email = ?",
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return UserModels.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> updateUser(UserModels user) async {
    final db = await dbConnection.database;
    await db.update(
      'users',
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(String id) async {
    final db = await dbConnection.database;
    await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}