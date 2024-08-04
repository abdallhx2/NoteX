import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notex/database/Firebase/firebase_options.dart';
import 'package:notex/models/user.dart';
import 'package:notex/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final SyncService syncService;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserBloc({required this.userRepository, required this.syncService})
      : super(UserLoading()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<LoadUserEvent>(_onLoadUser);
    on<UpdateUserEvent>(_onUpdateUser);
  }

  Future<void> _onLoadUser(LoadUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final userId = await syncService.getUserId();
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        String userName = userDoc['name'] as String;
        emit(UserNameLoaded(userName: userName));
      } else {
        emit(UserError(message: 'User not found'));
      }
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userCredential.user!.uid);
      emit(UserLoggedIn(userId: userCredential.user!.uid));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }


  Future<void> _onUpdateUser(
      UpdateUserEvent event, Emitter<UserState> emit) async {
    try {
      await userRepository.updateUser(event.user);
      add(LoadUserEvent());
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}
