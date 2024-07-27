// note_stream.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notex/models/note.dart';

class NoteStream {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Note>> getNotesStream() {
    return _firestore.collection('notes').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Note(
          id: doc.id,
          title: data['title'] ?? '',
          content: data['content'] ?? '',
          date: (data['date'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }
}
