// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:notex/bloc/note_bloc/note_bloc.dart';
// import 'package:notex/bloc/note_bloc/note_state.dart';
// import 'package:notex/models/note.dart';
// import 'package:notex/widgets/note_card.dart';

// class showNote extends StatefulWidget {
//   const showNote({super.key});

//   @override
//   State<showNote> createState() => _showNoteState();
// }

// class _showNoteState extends State<showNote> {
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: BlocBuilder<NoteBloc, NoteState>(
//         builder: (context, state) {
//           if (state is NotesLoading) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is NotesLoaded) {
//             return _buildNotesList(state.notes, 'لا توجد ملاحظات');
//           } else if (state is NotesSearchResult) {
//             return _buildNotesList(state.searchResults, 'لا توجد نتائج');
//           } else if (state is NotesError) {
//             return Center(child: Text('خطأ: ${state.message}'));
//           } else {
//             return Center(child: Text('لا توجد بيانات'));
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildNotesList(List<Note> notes, String emptyMessage) {
//     if (notes.isEmpty) {
//       return Center(child: Text(emptyMessage));
//     } else {
//       return ListView.builder(
//         itemCount: notes.length,
//         itemBuilder: (context, index) {
//           final note = notes[index];
//           return NoteCard(note: note);
//         },
//       );
//     }
//   }
// }
// // class showNote extends StatelessWidget {
// //   const showNote({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Expanded(
// //       child: BlocBuilder<NoteBloc, NoteState>(
// //         builder: (context, state) {
// //           if (state is NotesLoading) {
// //             return Center(child: CircularProgressIndicator());
// //           } else if (state is NotesLoaded) {
// //             if (state.notes.isEmpty) {
// //               return Center(child: Text('لا توجد ملاحظات'));
// //             } else {
// //               return ListView.builder(
// //                 itemCount: state.notes.length,
// //                 itemBuilder: (context, index) {
// //                   final note = state.notes[index];
// //                   return NoteCard(note: note);
// //                 },
// //               );
// //             }
// //           } else if (state is NotesSearchResult) {
// //             if (state.searchResults.isEmpty) {
// //               return Center(child: Text('لا توجد نتائج'));
// //             } else {
// //               return ListView.builder(
// //                 itemCount: state.searchResults.length,
// //                 itemBuilder: (context, index) {
// //                   final note = state.searchResults[index];
// //                   return NoteCard(note: note);
// //                 },
// //               );
// //             }
// //           } else if (state is NotesError) {
// //             return Center(child: Text('خطأ: ${state.message}'));
// //           }
// //           return Center(child: Text('لا توجد بيانات'));
// //         },
// //       ),
// //     );
// //   }
// // }
