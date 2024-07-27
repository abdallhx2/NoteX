import 'package:equatable/equatable.dart';
import 'package:notex/models/note.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

class NotesLoading extends NoteState {}

class NotesLoaded extends NoteState {
  final List<Note> notes;

  const NotesLoaded({required this.notes});

  @override
  List<Object> get props => [notes];
}

class NotesError extends NoteState {
  final String message;

  const NotesError({required this.message});

  @override
  List<Object> get props => [message];
}

class NotesSearchResult extends NoteState {
  final List<Note> searchResults;

  const NotesSearchResult({required this.searchResults});

  @override
  List<Object> get props => [searchResults];
}