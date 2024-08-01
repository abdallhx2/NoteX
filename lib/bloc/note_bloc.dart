import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notex/database/Firebase/firebase_options.dart';
import 'package:notex/repositories/note_repository.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository noteRepository;
  final SyncService syncService;

  NoteBloc({required this.noteRepository, required this.syncService})
      : super(NotesLoading()) {
    on<LoadNotesEvent>(_onLoadNotes);
    on<AddNoteEvent>(_onAddNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
    on<SearchNotesEvent>(_onSearchNotes);
    on<SyncNotesEvent>(_onSyncNotes);
    on<SetSyncOptionsEvent>(_onSetSyncOptions);
  }

  Future<void> _onLoadNotes(
      LoadNotesEvent event, Emitter<NoteState> emit) async {
    emit(NotesLoading());
    try {
      final notes =
          await noteRepository.getNotes(await syncService.getUserId());
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onAddNote(AddNoteEvent event, Emitter<NoteState> emit) async {
    try {
      await noteRepository.addNote(event.note);
      await syncService.syncNote(event.note);
      add(LoadNotesEvent());
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onUpdateNote(
      UpdateNoteEvent event, Emitter<NoteState> emit) async {
    try {
      await noteRepository.updateNote(event.note);
      await syncService.syncNote(event.note);
      add(LoadNotesEvent());
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onDeleteNote(
      DeleteNoteEvent event, Emitter<NoteState> emit) async {
    try {
      await noteRepository.deleteNote(event.id);
      // Здесь нужно добавить удаление заметки из облака
      add(LoadNotesEvent());
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onSearchNotes(
      SearchNotesEvent event, Emitter<NoteState> emit) async {
    emit(NotesLoading());
    try {
      final notes = await noteRepository.searchNotes(
          event.query, await syncService.getUserId());
      emit(NotesSearchResult(searchResults: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onSyncNotes(
      SyncNotesEvent event, Emitter<NoteState> emit) async {
    try {
      await syncService.fullSync(event.userId);
      emit(NotesSynced());
      add(LoadNotesEvent());
    } catch (e) {
      emit(NotesSyncError(message: e.toString()));
    }
  }

  Future<void> _onSetSyncOptions(
      SetSyncOptionsEvent event, Emitter<NoteState> emit) async {
    try {
      await syncService.setSyncOptions(
        autoSync: event.autoSync,
        syncInterval: event.syncInterval,
        syncOnWifiOnly: event.syncOnWifiOnly,
      );
      emit(SyncOptionsSet(
        autoSync: event.autoSync,
        syncInterval: event.syncInterval,
        syncOnWifiOnly: event.syncOnWifiOnly,
      ));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }
}
