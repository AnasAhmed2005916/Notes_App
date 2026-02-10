import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course1/features/notes/views/cubit/Note%20Cubit/note_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(InitNoteState());
  Future<void> getNotes(String categoryId) async {
    emit(LoadingNoteState());
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('notes')
          .where('categoryId', isEqualTo: categoryId)
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      emit(LoadedNoteState(notes: querySnapshot.docs));
    } catch (e) {
      emit(ErrorNoteState('Failed to load notes'));
    }
  }

  Future<void> addNote({
    required String title,
    required String content,
    required String categoryId,
  }) async {
    try {
      emit(AddNoteLoading());
      await FirebaseFirestore.instance.collection('notes').add({
        'title': title,
        'content': content,
        'categoryId': categoryId,
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });
      emit(AddNoteSuccess());
    } catch (e) {
      emit(AddNoteError(errorMsg: e.toString()));
    }
  }
}
