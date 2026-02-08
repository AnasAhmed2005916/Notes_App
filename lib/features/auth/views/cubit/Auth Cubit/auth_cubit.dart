import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_course1/features/auth/views/cubit/Auth%20Cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(InitAuthState());
  Future<void> Login({required String email, required String password}) async {
    emit(LoadingAuthState());
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!credential.user!.emailVerified) {
        throw FirebaseAuthException(
          code: 'Email-not-verified',
          message: 'Please verify your email first',
        );
      }
      emit(SuccessAuthState());
    } on FirebaseAuthException catch (e) {
      emit(FailAuthState(ErrorMsg: e.message ?? 'Login Failed'));
    } catch (e) {
      emit(FailAuthState(ErrorMsg: 'Something went wrong'));
    }
  }

  Future<void> SignUp({
    required String email,
    required String password,
    required String username,
  }) async {
    emit(LoadingAuthState());
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await credential.user!.sendEmailVerification();
      emit(SuccessAuthState());
    } on FirebaseAuthException catch (e) {
      emit(FailAuthState(ErrorMsg: e.message ?? 'SignUp Failed'));
    }
  }

  
}
