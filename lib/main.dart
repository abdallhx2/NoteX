import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notex/bloc/note_bloc.dart';
import 'package:notex/pages/homePage/body.dart';

import 'repositories/note_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NoteRepository noteRepository = NoteRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notx',
      home: BlocProvider(
        create: (context) => NoteBloc(noteRepository: noteRepository),
        child: MaterialApp(
          home: body(),
        ),
      ),
    );
  }
}
