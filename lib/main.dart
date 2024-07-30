import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notex/bloc/note_bloc.dart';
import 'package:notex/database/SQLite/database_helper.dart';
import 'package:notex/pages/homePage/body.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final DBConnection _dbConnection = DBConnection();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notx',
      home: BlocProvider(
        create: (context) => NoteBloc(noteRepository: _dbConnection),
        child: MaterialApp(
          home: body(),
        ),
      ),
    );
  }
}
