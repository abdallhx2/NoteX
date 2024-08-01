import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notex/bloc/note_bloc/note_bloc.dart';
import 'package:notex/bloc/note_bloc/note_event.dart';
import 'package:notex/bloc/note_bloc/note_state.dart';
import 'package:notex/bloc/user_bloc/user_bloc.dart';
import 'package:notex/bloc/user_bloc/user_event.dart';
import 'package:notex/database/Firebase/firebase_options.dart';
import 'package:notex/database/SQLite/database_connction.dart';
import 'package:notex/pages/homePage/showNote.dart';
import 'package:notex/pages/notePage.dart';

// class HomeBody extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Home')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Welcome to the Home Page'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   // Trigger the logout event in Bloc
//                   context.read<UserBloc>().add(LogoutEvent());
//                   await FirebaseAuth.instance.signOut();
//                   Navigator.pushReplacementNamed(context, '/login');
//                 } catch (e) {
//                   // Handle logout errors if needed
//                   print('Logout failed: ${e.toString()}');
//                 }
//               },
//               child: Text('Logout'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
                final userId = FirebaseAuth.instance.currentUser?.uid;
                if (userId != null) {
                  await SyncService().fullSync(
                      userId); // تأكد من وجود هذه الدالة في SyncService
                  BlocProvider.of<NoteBloc>(context).add(LoadNotesEvent());
                  // لا حاجة لدالة initDatabaseWithFakeData هنا، قم بإدخال البيانات الوهمية عند الحاجة فقط
                } else {
                  print('User is not logged in');
                }
              } catch (e) {
                print('Error occurred: $e');
              }
            },
          ),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Trigger the logout event in Bloc
                  context.read<UserBloc>().add(LogoutEvent());
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                } catch (e) {
                  // Handle logout errors if needed
                  print('Logout failed: ${e.toString()}');
                }
              },
              child: Text('Logout'),
            ),
            SizedBox(height: 8.0),
            showNote()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewNotePage()),
          );
          if (newNote != null) {
            BlocProvider.of<NoteBloc>(context).add(AddNoteEvent(note: newNote));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
