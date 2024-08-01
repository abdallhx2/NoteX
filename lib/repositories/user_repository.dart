import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notex/models/user.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // تسجيل مستخدم جديد
  Future<UserModels?> register(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // إضافة بيانات المستخدم إلى Firestore
      UserModels newUser = UserModels(
        id: userCredential.user!.uid,
        name: '',
        email: email,
        phoneNumber: '',
        password: password,
        // أضف بيانات أخرى للمستخدم هنا حسب الحاجة
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toMap());
      //await DBConnection().insertUser(newUser);

      return newUser;
    } catch (e) {
      print('Registration failed: ${e.toString()}');
      return null;
    }
  }

  // تسجيل الدخول
  Future<String?> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid;
    } catch (e) {
      print('Login failed: ${e.toString()}');
      return null;
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      // يمكن تنظيف بيانات الجلسة إذا لزم الأمر
      // مثل حذف معلومات المستخدم من SharedPreferences
    } catch (e) {
      print('Logout failed: ${e.toString()}');
    }
  }

  // الحصول على المستخدم الحالي
  Future<UserModels?> getCurrentUser() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      // استرجاع بيانات المستخدم من Firestore
      DocumentSnapshot docSnapshot =
          await _firestore.collection('users').doc(user.uid).get();
      return UserModels.fromMap(docSnapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  // إضافة مستخدم
  Future<void> addUser(UserModels user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      print('Add user failed: ${e.toString()}');
    }
  }

  // الحصول على مستخدم بواسطة ID
  Future<UserModels?> getUserById(String id) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('users').doc(id).get();
      if (docSnapshot.exists) {
        return UserModels.fromMap(docSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Get user by ID failed: ${e.toString()}');
      return null;
    }
  }

  // الحصول على مستخدم بواسطة Email
  Future<UserModels?> getUserByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return UserModels.fromMap(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Get user by email failed: ${e.toString()}');
      return null;
    }
  }

  // تحديث مستخدم
  Future<void> updateUser(UserModels user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      print('Update user failed: ${e.toString()}');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _firestore.collection('users').doc(id).delete();
    } catch (e) {
      print('Delete user failed: ${e.toString()}');
    }
  }
}
