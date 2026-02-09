import 'package:cloud_firestore/cloud_firestore.dart';

class HomeState {}

class InitHomeState extends HomeState {}

class LoadingHomeState extends HomeState {}

class LoadedHomeState extends HomeState {
  final List<QueryDocumentSnapshot> data;
  LoadedHomeState({required this.data});
}

class ErrorHomeState extends HomeState{
  final String errorMsg;
  ErrorHomeState({required this.errorMsg});
}
