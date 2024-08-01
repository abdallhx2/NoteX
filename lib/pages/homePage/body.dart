import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notex/bloc/note_bloc.dart';
import 'package:notex/bloc/note_event.dart';
import 'package:notex/bloc/note_state.dart';
import 'package:notex/database/Firebase/firebase_options.dart';
import 'package:notex/database/SQLite/database_connction.dart';
import 'package:notex/pages/homePage/showNote.dart';
import 'package:notex/pages/notePage.dart';

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Notex'),
        actions: [
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () async {
              try {
                // تأكد من تعيين userId بشكل صحيح
                final userId = await FirebaseAuth.instance.currentUser?.uid;
                if (userId != null) {
                  await SyncService().fullSync(userId); // تمرير userId هنا
                  BlocProvider.of<NoteBloc>(context).add(LoadNotesEvent());
                  await initDatabaseWithFakeData(); // تأكد من وجود بيانات وهمية فقط عند الحاجة
                } else {
                  // التعامل مع حالة عدم وجود userId
                  print('User is not logged in');
                }
              } catch (e) {
                print('Error occurred: $e');
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'بحث',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                BlocProvider.of<NoteBloc>(context)
                    .add(SearchNotesEvent(query: value));
              },
            ),
            const SizedBox(height: 8.0),
            BlocBuilder<NoteBloc, NoteState>(
              builder: (context, state) {
                if (state is NotesLoaded) {
                  return Text('Note ${state.notes.length}');
                } else {
                  return Text('Note 0');
                }
              },
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                ChoiceChip(label: Text('الكل'), selected: true),
                SizedBox(width: 8.0),
                ChoiceChip(label: Text('خاص بي'), selected: false),
                SizedBox(width: 8.0),
                ChoiceChip(label: Text('العمل'), selected: false),
              ],
            ),
            SizedBox(height: 8.0),
            showNote()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewNotePage()),
          ).then((newNote) {
            if (newNote != null) {
              BlocProvider.of<NoteBloc>(context)
                  .add(AddNoteEvent(note: newNote));
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
