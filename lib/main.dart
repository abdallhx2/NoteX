import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notex/bloc/note_bloc.dart';
import 'package:notex/database/Firebase/firebase_options.dart';
import 'package:notex/pages/auth_pages/authLogin.dart';
import 'package:notex/repositories/note_repository.dart';
import 'package:notex/route/appRoute.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SyncService _syncService = SyncService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notx',
      home: BlocProvider(
        create: (context) => NoteBloc(
            noteRepository: NoteRepository(), syncService: _syncService),
        child: MaterialApp(
          home: LoginPage(),
          initialRoute: AppRoutes.login,
          onGenerateRoute: AppRoutes.generateRoute,
        ),
      ),
    );
  }
}
