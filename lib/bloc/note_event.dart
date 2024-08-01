import 'package:equatable/equatable.dart';
import 'package:notex/models/note.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class LoadNotesEvent extends NoteEvent {}

class AddNoteEvent extends NoteEvent {
  final Note note;

  const AddNoteEvent({required this.note});

  @override
  List<Object> get props => [note];
}

class UpdateNoteEvent extends NoteEvent {
  final Note note;

  const UpdateNoteEvent({required this.note});

  @override
  List<Object> get props => [note];
}

class DeleteNoteEvent extends NoteEvent {
  final String id;

  const DeleteNoteEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class SearchNotesEvent extends NoteEvent {
  final String query;

  SearchNotesEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class SyncNotesEvent extends NoteEvent {
  final String userId;

  const SyncNotesEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class SetSyncOptionsEvent extends NoteEvent {
  final bool autoSync;
  final int syncInterval;
  final bool syncOnWifiOnly;

  const SetSyncOptionsEvent({
    required this.autoSync,
    required this.syncInterval,
    required this.syncOnWifiOnly,
  });

  @override
  List<Object> get props => [autoSync, syncInterval, syncOnWifiOnly];
}
