import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notex/database/SQLite/database_helper.dart';
import 'package:notex/models/note.dart';

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DBConnection _dbHelper = DBConnection();

  Future<String> _getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // استخدام معرف مستخدم وهمي إذا لم يكن هناك مستخدم مسجل دخول
      return 'dummyUserId';
    }
    return user.uid;
  }

  Future<void> syncToCloud() async {
    String userId = await _getUserId();
    List<Note> localNotes = await _dbHelper.getNotes();

    for (var note in localNotes) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .doc(note.id)
          .set(note.toMap());
    }
  }

  Future<void> syncFromCloud() async {
    String userId = await _getUserId();
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .get();

    for (var doc in snapshot.docs) {
      Note note = Note.fromMap(doc.data() as Map<String, dynamic>);
      Note? existingNote = await _dbHelper.getNoteById(note.id);

      // if (existingNote != null) {
      //   if (note.updatedAt.isAfter(existingNote.updatedAt)) {
      //     await _dbHelper.updateNote(note);
      //   }
      // } else
      {
        await _dbHelper.addNote(note);
      }
    }
  }

  Future<void> syncNote(Note note) async {
    String userId = await _getUserId();
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(note.id)
        .set(note.toMap());
  }

  Future<void> deleteNoteFromCloud(String noteId) async {
    String userId = await _getUserId();
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }

  Future<void> fullSync(String userId) async {
    await syncToCloud();
    await syncFromCloud();
  }
}
