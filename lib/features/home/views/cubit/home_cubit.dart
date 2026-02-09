import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course1/features/home/views/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitHomeState());

  getData() async {
    try {
      emit(LoadingHomeState());
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      emit(LoadedHomeState(data: querySnapshot.docs));
    } catch (e) {
      emit(ErrorHomeState(errorMsg: e.toString()));
    }
  }

  Future<void> deleteCategory(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(docId)
          .delete();
      getData();
    } catch (e) {
      emit(ErrorHomeState(errorMsg: e.toString()));
    }
  }

  Future<void> updateCategory({
    required String docId,
    required String newName,
  }) async {
    try {
      emit(LoadingHomeState());
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(docId)
          .update({'name': newName});
      await getData();
    } catch (e) {
      emit(ErrorHomeState(errorMsg: e.toString()));
    }
  }
}
