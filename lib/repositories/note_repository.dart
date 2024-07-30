

import 'package:notex/models/note.dart';
abstract class NoteRepository {
  Future<List<Note>> getNotes();
  Future<void> addNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String id);
  Future<Note?> getNoteById(String id);
  Future<List<Note>> searchNotes(String query);
  Future<void> deleteNote(String id) async {
    await _syncService.deleteNoteFromCloud(id); // تأكد من تنفيذ الحذف في Firestore
    // يمكن إضافة كود لحذف الملاحظة محلياً إذا لزم الأمر
  }
}
