class AuthState {}

class InitAuthState extends AuthState {}

class SuccessAuthState extends AuthState{}

class FailAuthState extends AuthState{
  String ErrorMsg;
  FailAuthState({required this.ErrorMsg});
}

class LoadingAuthState extends AuthState{}
