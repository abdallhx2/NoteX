

import 'package:notex/database/SQLite/database_connction.dart';
import 'package:notex/models/note.dart';
import 'package:sqflite/sqflite.dart';

class NoteRepository {
  final dbConnection = DBConnection();

  Future<List<Note>> getNotes(String userId) async {
    final db = await dbConnection.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: "userId = ?",
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<void> addNote(Note note) async {
    final db = await dbConnection.database;
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateNote(Note updatedNote) async {
    final db = await dbConnection.database;
    await db.update(
      'notes',
      updatedNote.toMap(),
      where: "id = ?",
      whereArgs: [updatedNote.id],
    );
  }

  Future<void> deleteNote(String id) async {
    final db = await dbConnection.database;
    await db.delete(
      'notes',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<Note?> getNoteById(String id) async {
    final db = await dbConnection.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Note>> searchNotes(String query, String userId) async {
    final db = await dbConnection.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'userId = ? AND title LIKE ?',
      whereArgs: [userId, '%$query%'],
    );

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }
}