import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notex/bloc/note_bloc.dart';
import 'package:notex/bloc/note_event.dart';
import 'package:notex/models/note.dart';

class NewNotePage extends StatefulWidget {
  final Note? note;

  NewNotePage({this.note});

  @override
  _NewNotePageState createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'إضافة مذكرة' : 'تعديل مذكرة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'العنوان',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'المحتوى',
              ),
              maxLines: 10,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final updatedNote = Note(
                  id: widget.note?.id ?? DateTime.now().toString(),
                  title: _titleController.text,
                  content: _contentController.text,
                  date: DateTime.now(),
                );

                if (widget.note == null) {
                  // إضافة ملاحظة جديدة
                  BlocProvider.of<NoteBloc>(context).add(AddNoteEvent(note: updatedNote));
                } else {
                  // تحديث ملاحظة موجودة
                  BlocProvider.of<NoteBloc>(context).add(UpdateNoteEvent(note: updatedNote));
                }

                Navigator.pop(context);
              },
              child: Text(widget.note == null ? 'إضافة' : 'تحديث'),
            ),
          ],
        ),
      ),
    );
  }
}
