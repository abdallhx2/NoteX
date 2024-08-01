import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notex/database/Firebase/firebase_options.dart';
import 'package:notex/repositories/user_repository.dart';
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
    on<AddUserEvent>(_onAddUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
    on<RegisterEvent>(_onRegister); 

  }

  Future<void> _onLogin(LoginEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      // تسجيل الدخول باستخدام Firebase Auth
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      // حفظ ID المستخدم في خدمة المزامنة
      await syncService.saveUserId(userCredential.user!.uid);

      // تحميل بيانات المستخدم من الريبو
      final user = await userRepository.getUserById(userCredential.user!.uid);
      emit(UserLoggedIn(userId: userCredential.user!.uid));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await _firebaseAuth.signOut();
      await syncService.clearUserId();
      emit(UserLoggedOut());
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _onLoadUser(LoadUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final userId = await syncService.getUserId();
      final user = await userRepository.getUserById(userId);
      emit(UserLoaded(user: user!));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _onAddUser(AddUserEvent event, Emitter<UserState> emit) async {
    try {
      await userRepository.addUser(event.user);
      add(LoadUserEvent());
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _onUpdateUser(UpdateUserEvent event, Emitter<UserState> emit) async {
    try {
      await userRepository.updateUser(event.user);
      add(LoadUserEvent());
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _onDeleteUser(DeleteUserEvent event, Emitter<UserState> emit) async {
    try {
      await userRepository.deleteUser(event.id);
      add(LoadUserEvent());
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

   Future<void> _onRegister(RegisterEvent event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final user = await userRepository.register(event.email, event.password);
      if (user != null) {
        emit(UserRegistered(user: user));
      } else {
        emit(UserError(message: 'Registration failed'));
      }
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}

