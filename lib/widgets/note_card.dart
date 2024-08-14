import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notex/bloc/note_bloc/note_bloc.dart';
import 'package:notex/bloc/note_bloc/note_event.dart';
import 'package:notex/models/note.dart';
import 'package:notex/pages/notePage.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class NoteCard extends StatelessWidget {
  final Note note;

  NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    final document = quill.Document.fromJson(jsonDecode(note.content));
    final plainText = document.toPlainText();

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewNotePage(note: note),
            ),
          );
        },
        onLongPress: () {
          final noteBloc = BlocProvider.of<NoteBloc>(context);
          noteBloc.add(DeleteNoteEvent(id: note.id));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(note.title,
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Text(plainText, maxLines: 3, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
