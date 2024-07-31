import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notex/database/SQLite/database_connction.dart';
import 'package:notex/models/note.dart';

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DBConnection _dbHelper = DBConnection();

  // دالة خاصة للحصول على معرف المستخدم الحالي
  Future<String> _getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    // إذا لم يكن هناك مستخدم مسجل الدخول، نرجع معرف مستخدم افتراضي
    if (user == null) {
      return 'dummyUserId';
    }
    // نرجع معرف المستخدم الفعلي
    return user.uid;
  }

  // دالة لمزامنة البيانات من قاعدة البيانات المحلية إلى Firestore
  Future<void> syncToCloud() async {
    String userId = await _getUserId(); // الحصول على معرف المستخدم
    List<Note> localNotes = await _dbHelper
        .getNotes(); // جلب جميع الملاحظات من قاعدة البيانات المحلية
    List<String> localNoteIds = localNotes
        .map((note) => note.id)
        .toList(); // استخراج معرفات الملاحظات المحلية

    // 1. تحديث/إضافة الملاحظات إلى Firestore
    for (var note in localNotes) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .doc(note.id)
          .set(note.toMap()); // تعيين الملاحظة في Firestore
    }

    // 2. الحصول على قائمة الملاحظات من Firestore
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .get(); // جلب جميع الملاحظات من Firestore

    List<String> firestoreNoteIds = snapshot.docs
        .map((doc) => doc.id)
        .toList(); // استخراج معرفات الملاحظات من Firestore

    // 3. حذف الملاحظات التي لم تعد موجودة في قاعدة البيانات المحلية
    for (var id in firestoreNoteIds) {
      if (!localNoteIds.contains(id)) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('notes')
            .doc(id)
            .delete(); // حذف الملاحظة من Firestore إذا لم تكن موجودة محليًا
      }
    }
  }

  // دالة لمزامنة البيانات من Firestore إلى قاعدة البيانات المحلية
  Future<void> syncFromCloud() async {
    String userId = await _getUserId(); // الحصول على معرف المستخدم
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .get(); // جلب جميع الملاحظات من Firestore

    List<String> cloudNoteIds = snapshot.docs
        .map((doc) => doc.id)
        .toList(); // استخراج معرفات الملاحظات من Firestore
    List<Note> localNotes = await _dbHelper
        .getNotes(); // جلب جميع الملاحظات من قاعدة البيانات المحلية
    List<String> localNoteIds = localNotes
        .map((note) => note.id)
        .toList(); // استخراج معرفات الملاحظات المحلية

    // 1. تحديث/إضافة الملاحظات من Cloud إلى قاعدة البيانات المحلية
    for (var doc in snapshot.docs) {
      Note note = Note.fromMap(doc.data()
          as Map<String, dynamic>); // تحويل بيانات الوثيقة إلى كائن Note
      Note? existingNote = await _dbHelper
          .getNoteById(note.id); // التحقق مما إذا كانت الملاحظة موجودة محليًا

      if (existingNote != null) {
        // إذا كانت الملاحظة موجودة، التحقق مما إذا كانت النسخة من Cloud أحدث
        if (note.lastUpdated.isAfter(existingNote.lastUpdated)) {
          await _dbHelper.updateNote(
              note); // تحديث الملاحظة في قاعدة البيانات المحلية إذا كانت النسخة من Cloud أحدث
        }
      } else {
        // إذا لم تكن الملاحظة موجودة محليًا، إضافتها
        await _dbHelper.addNote(note);
      }
    }

    // 2. حذف الملاحظات التي تم حذفها من Cloud
    for (var id in localNoteIds) {
      if (!cloudNoteIds.contains(id)) {
        await _dbHelper.deleteNote(
            id); // حذف الملاحظة من قاعدة البيانات المحلية إذا لم تكن موجودة في Cloud
      }
    }
  }

  // دالة لمزامنة ملاحظة واحدة إلى Cloud
  Future<void> syncNote(Note note) async {
    String userId = await _getUserId(); // الحصول على معرف المستخدم
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(note.id)
        .set(note.toMap()); // تعيين الملاحظة في Firestore
  }

  // دالة لمزامنة كاملة بين قاعدة البيانات المحلية و Firestore
  Future<void> fullSync(String userId) async {
    await syncToCloud(); // مزامنة البيانات من قاعدة البيانات المحلية إلى Firestore
    await syncFromCloud(); // مزامنة البيانات من Firestore إلى قاعدة البيانات المحلية
  }
}
