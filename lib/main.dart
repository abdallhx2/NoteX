import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notex/src/bloc/note_bloc/note_bloc.dart';
import 'package:notex/src/bloc/user_bloc/user_bloc.dart';
import 'package:notex/src/services/database_services/firebase_options.dart';

import 'package:notex/src/repositories/note_repository.dart';
import 'package:notex/src/repositories/user_repository.dart';
import 'package:notex/src/route/appRoute.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserRepository userRepository = UserRepository();
  final SyncService syncService = SyncService();
  final NoteRepository noteRepository = NoteRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc(
            userRepository: userRepository,
            syncService: syncService,
          ),
        ),
        BlocProvider(
          create: (context) => NoteBloc(
              noteRepository: noteRepository, syncService: syncService),
        ),
      ],
      child: MaterialApp(
        title: 'Notex',
        initialRoute: AppRoutes.main,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}

// class AuthChecker extends StatefulWidget {
//   @override
//   _AuthCheckerState createState() => _AuthCheckerState();
// }

// class _AuthCheckerState extends State<AuthChecker> {
//   bool _isLoggedIn = false;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }

//   Future<void> _checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userId = prefs.getString('userId');

//     if (userId != null && userId.isNotEmpty) {
//       setState(() {
//         _isLoggedIn = true;
//       });
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     } else {
//       return _isLoggedIn ? HomeBody() : SignInPage();
//     }
//   }
// }
