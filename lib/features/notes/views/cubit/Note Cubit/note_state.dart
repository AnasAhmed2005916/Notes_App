import 'package:cloud_firestore/cloud_firestore.dart';

class NoteState {}

class InitNoteState extends NoteState {}

class LoadedNoteState extends NoteState {
  final List<QueryDocumentSnapshot> notes;
  LoadedNoteState({required this.notes});
}

class LoadingNoteState extends NoteState {}

class ErrorNoteState extends NoteState {
  final String errorMsg;
  ErrorNoteState(this.errorMsg);
}
