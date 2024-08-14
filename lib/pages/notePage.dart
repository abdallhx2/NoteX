import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notex/bloc/note_bloc/note_bloc.dart';
import 'package:notex/bloc/note_bloc/note_event.dart';
import 'package:notex/models/note.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:convert';

class NewNotePage extends StatefulWidget {
  final Note? note;

  NewNotePage({this.note});

  @override
  _NewNotePageState createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  final TextEditingController _titleController = TextEditingController();
  late quill.QuillController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController = widget.note != null
        ? quill.QuillController(
            document: quill.Document.fromJson(jsonDecode(widget.note!.content)),
            selection: TextSelection.collapsed(offset: 0),
          )
        : quill.QuillController.basic();

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.note == null ? 'إضافة مذكرة' : _titleController.text),
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
            Expanded(
              child: quill.QuillEditor.basic(
                controller: _contentController,
              ),
            ),
            quill.QuillToolbar.simple(controller: _contentController,
             configurations:  quill.QuillSimpleToolbarConfigurations(
    buttonOptions: QuillToolbarButtonOptions(
      base: QuillToolbarBaseButtonOptions(
        globalIconSize: 20,
        globalIconButtonFactor: 1.4,
      ),
    ),
  ),),
            
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isEmpty ||
                    _contentController.document.toPlainText().trim().isEmpty) {
                  // عرض رسالة خطأ أو إشعار
                  return;
                }

                final updatedNote = Note(
                  id: widget.note?.id ?? DateTime.now().toString(),
                  title: _titleController.text,
                  content: jsonEncode(
                      _contentController.document.toDelta().toJson()),
                  date: DateTime.now(),
                  lastUpdated: DateTime.now(),
                  userId: '',
                );

                if (widget.note == null) {
                  // إضافة ملاحظة جديدة
                  BlocProvider.of<NoteBloc>(context)
                      .add(AddNoteEvent(note: updatedNote));
                } else {
                  // تحديث ملاحظة موجودة
                  BlocProvider.of<NoteBloc>(context)
                      .add(UpdateNoteEvent(note: updatedNote));
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
