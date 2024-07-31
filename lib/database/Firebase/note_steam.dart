// استيراد مكتبات Flutter الضرورية
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notex/models/note.dart';

class NoteStream {
  // إنشاء مثيل من FirebaseFirestore للتفاعل مع قاعدة بيانات Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // دالة لإرجاع Stream من قائمة الملاحظات
  Stream<List<Note>> getNotesStream() {
    // الحصول على Stream من مجموعة 'notes' في Firestore
    return _firestore.collection('notes').snapshots().map((snapshot) {
      // تحويل بيانات الوثائق إلى قائمة من كائنات Note
      return snapshot.docs.map((doc) {
        final data = doc.data(); // الحصول على بيانات الوثيقة
        return Note(
          id: doc.id, // استخدام معرف الوثيقة كمُعرف للملاحظة
          title: data['title'] ?? '', // الحصول على عنوان الملاحظة
          content: data['content'] ?? '', // الحصول على محتوى الملاحظة
          date: (data['date'] as Timestamp).toDate(), // تحويل تاريخ الوثيقة من نوع Timestamp إلى DateTime
          lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(), // تحويل آخر تحديث من نوع Timestamp إلى DateTime، أو تعيين الوقت الحالي إذا لم يكن موجودًا
        );
      }).toList(); // تحويل جميع الوثائق إلى قائمة من كائنات Note
    });
  }
}
