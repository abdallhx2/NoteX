import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notex/bloc/note_bloc/note_bloc.dart';
import 'package:notex/bloc/note_bloc/note_state.dart';
import 'package:notex/widgets/note_card.dart';

class showNote extends StatelessWidget {
  const showNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NotesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NotesLoaded) {
            if (state.notes.isEmpty) {
              return Center(child: Text('لا توجد ملاحظات'));
            } else {
              return ListView.builder(
                itemCount: state.notes.length,
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  return NoteCard(note: note);
                },
              );
            }
          } else if (state is NotesSearchResult) {
            if (state.searchResults.isEmpty) {
              return Center(child: Text('لا توجد نتائج'));
            } else {
              return ListView.builder(
                itemCount: state.searchResults.length,
                itemBuilder: (context, index) {
                  final note = state.searchResults[index];
                  return NoteCard(note: note);
                },
              );
            }
          } else if (state is NotesError) {
            return Center(child: Text('خطأ: ${state.message}'));
          }
          return Center(child: Text('لا توجد بيانات'));
        },
      ),
    );
  }
}
// class showNote extends StatelessWidget {
//   const showNote({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: BlocBuilder<NoteBloc, NoteState>(
//         builder: (context, state) {
//           if (state is NotesLoading) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is NotesLoaded) {
//             if (state.notes.isEmpty) {
//               return Center(child: Text('لا توجد ملاحظات'));
//             } else {
//               return ListView.builder(
//                 itemCount: state.notes.length,
//                 itemBuilder: (context, index) {
//                   final note = state.notes[index];
//                   return NoteCard(note: note);
//                 },
//               );
//             }
//           } else if (state is NotesSearchResult) {
//             if (state.searchResults.isEmpty) {
//               return Center(child: Text('لا توجد نتائج'));
//             } else {
//               return ListView.builder(
//                 itemCount: state.searchResults.length,
//                 itemBuilder: (context, index) {
//                   final note = state.searchResults[index];
//                   return NoteCard(note: note);
//                 },
//               );
//             }
//           } else if (state is NotesError) {
//             return Center(child: Text('خطأ: ${state.message}'));
//           }
//           return Center(child: Text('لا توجد بيانات'));
//         },
//       ),
//     );
//   }
// }
