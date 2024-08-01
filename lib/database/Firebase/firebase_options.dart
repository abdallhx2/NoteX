import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notex/models/note.dart';
import 'package:notex/models/user.dart' as AppUser;
import 'package:notex/repositories/note_repository.dart';
import 'package:notex/repositories/user_repository.dart';

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NoteRepository _noteRepository = NoteRepository();
  final UserRepository _userRepository = UserRepository();

  // دالة خاصة للحصول على معرف المستخدم الحالي
  Future<String> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }
    return user.uid;
  }

  // دالة لمزامنة البيانات من قاعدة البيانات المحلية إلى Firestore
  Future<void> syncToCloud() async {
    String userId = await getUserId();
    List<Note> localNotes = await _noteRepository.getNotes(userId);
    List<String> localNoteIds = localNotes.map((note) => note.id).toList();

    // 1. تحديث/إضافة الملاحظات إلى Firestore
    for (var note in localNotes) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .doc(note.id)
          .set(note.toMap());
    }

    // 2. حذف الملاحظات التي لم تعد موجودة في قاعدة البيانات المحلية
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .get();
    
    for (var doc in snapshot.docs) {
      if (!localNoteIds.contains(doc.id)) {
        await doc.reference.delete();
      }
    }
  }

  // دالة لمزامنة البيانات من Firestore إلى قاعدة البيانات المحلية
  Future<void> syncFromCloud() async {
    String userId = await getUserId();
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .get();

    List<String> cloudNoteIds = snapshot.docs.map((doc) => doc.id).toList();
    List<Note> localNotes = await _noteRepository.getNotes(userId);
    List<String> localNoteIds = localNotes.map((note) => note.id).toList();

    // 1. تحديث/إضافة الملاحظات من Cloud إلى قاعدة البيانات المحلية
    for (var doc in snapshot.docs) {
      Note note = Note.fromMap(doc.data() as Map<String, dynamic>);
      Note? existingNote = await _noteRepository.getNoteById(note.id);

      if (existingNote != null) {
        if (note.lastUpdated.isAfter(existingNote.lastUpdated)) {
          await _noteRepository.updateNote(note);
        }
      } else {
        await _noteRepository.addNote(note);
      }
    }

    // 2. حذف الملاحظات التي تم حذفها من Cloud
    for (var id in localNoteIds) {
      if (!cloudNoteIds.contains(id)) {
        await _noteRepository.deleteNote(id);
      }
    }
  }

  // دالة لمزامنة ملاحظة واحدة إلى Cloud
  Future<void> syncNote(Note note) async {
    String userId = await getUserId();
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(note.id)
        .set(note.toMap());
  }

  // دالة لمزامنة كاملة بين قاعدة البيانات المحلية و Firestore
  Future<void> fullSync(String userId) async {
    await syncToCloud();
    await syncFromCloud();
  }

  // دالة لمزامنة بيانات المستخدم
  Future<void> syncUserData() async {
    String userId = await getUserId();
    AppUser.UserModels? localUser = await _userRepository.getUserById(userId);
    
    if (localUser != null) {
      await _firestore
          .collection('users')
          .doc(userId)
          .set(localUser.toMap());
    }
  }

  // دالة لاسترجاع بيانات المستخدم من Firestore
  Future<void> fetchUserDataFromCloud() async {
    String userId = await getUserId();
    DocumentSnapshot userDoc = await _firestore
        .collection('users')
        .doc(userId)
        .get();

    if (userDoc.exists) {
      AppUser.UserModels cloudUser = AppUser.UserModels.fromMap(userDoc.data() as Map<String, dynamic>);
      await _userRepository.updateUser(cloudUser);
    }
  }

  // دالة لتحديد خيارات المزامنة
  Future<void> setSyncOptions({
    required bool autoSync,
    required int syncInterval,
    required bool syncOnWifiOnly,
  }) async {
    String userId = await getUserId();
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('syncOptions')
        .set({
      'autoSync': autoSync,
      'syncInterval': syncInterval,
      'syncOnWifiOnly': syncOnWifiOnly,
    });
  }

  // دالة للحصول على خيارات المزامنة
  Future<Map<String, dynamic>> getSyncOptions() async {
    String userId = await getUserId();
    DocumentSnapshot optionsDoc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('syncOptions')
        .get();

    if (optionsDoc.exists) {
      return optionsDoc.data() as Map<String, dynamic>;
    } else {
      // القيم الافتراضية
      return {
        'autoSync': true,
        'syncInterval': 15, // بالدقائق
        'syncOnWifiOnly': false,
      };
    }
  }
}