import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notex/database/Firebase/firebase_options.dart';
import 'package:notex/database/SQLite/database_helper.dart';
import 'note_event.dart';
import 'note_state.dart';

// note_bloc.dart
class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final DBConnection noteRepository;
  final SyncService _syncService = SyncService(); // تأكد من إنشاء نسخة من SyncService

  NoteBloc({required this.noteRepository}) : super(NotesLoading()) {
    on<LoadNotesEvent>(_onLoadNotes);
    on<AddNoteEvent>(_onAddNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
    on<SearchNotesEvent>(_onSearchNotes); // إضافة هنا
  }

  Future<void> _onLoadNotes(
      LoadNotesEvent event, Emitter<NoteState> emit) async {
    emit(NotesLoading());
    try {
      final notes = await noteRepository.getNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onAddNote(AddNoteEvent event, Emitter<NoteState> emit) async {
    try {
      await noteRepository.addNote(event.note);
      add(LoadNotesEvent()); // إعادة تحميل البيانات بعد إضافة الملاحظة
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onUpdateNote(
      UpdateNoteEvent event, Emitter<NoteState> emit) async {
    try {
      await noteRepository.updateNote(event.note);
      add(LoadNotesEvent());
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onDeleteNote(
      DeleteNoteEvent event, Emitter<NoteState> emit) async {
    try {
      await noteRepository.deleteNote(event.id);
      add(LoadNotesEvent());
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onSearchNotes(
      SearchNotesEvent event, Emitter<NoteState> emit) async {
    emit(NotesLoading());
    try {
      final notes = await noteRepository.searchNotes(event.query);
      emit(NotesSearchResult(searchResults: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }
}
