import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> testFirebaseConnection() async {
  await Firebase.initializeApp();
  try {
    final snapshot = await FirebaseFirestore.instance.collection('test').get();
    if (snapshot.docs.isNotEmpty) {
      print('Connection successful!');
    } else {
      print('Connection successful, but no data found.');
    }
  } catch (e) {
    print('Connection failed: $e');
  }
}
