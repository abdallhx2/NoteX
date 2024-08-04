import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notex/database/SQLite/database_connction.dart';
import 'package:notex/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }

  Future<UserModels?> registerUser(
      String email, String password, String phoneNumber, String name) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModels newUser = UserModels(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toMap());

      final db = await DBConnection().database;
      await db.insert(
        'users',
        newUser.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return newUser;
    } catch (e) {
      print('Registration failed: ${e.toString()}');
      return null;
    }
  }

  Future<String?> getUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }
      String userId = user.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc['name'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Failed to get user name: ${e.toString()}');
      return null;
    }
  }

  // Future<String?> getUserNameById(String id) async {
  //   final db = await DBConnection().database;
  //   try {
  //     final List<Map<String, dynamic>> maps = await db.query(
  //       'users',
  //       where: 'id  = ?',
  //       whereArgs: [id],
  //     );

  //     if (maps.isNotEmpty) {
  //       return maps.first['name'] as String?;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Get user by ID failed: ${e.toString()}');
  //     return null;
  //   }
  // }

  Future<String?> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await saveUserId(userCredential.user!.uid);
      
      return userCredential.user?.uid;
    } catch (e) {
      print('Login failed: ${e.toString()}');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      await clearUserId();
    } catch (e) {
      print('Logout failed: ${e.toString()}');
    }
  }

  Future<UserModels?> getCurrentUser() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('users').doc(user.uid).get();
      return UserModels.fromMap(docSnapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

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

  Future<void> updateUser(UserModels user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      print('Update user failed: ${e.toString()}');
    }
  }
}
