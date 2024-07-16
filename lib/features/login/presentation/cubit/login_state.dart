abstract class LoginState {}

class SuccessState extends LoginState {
  SuccessState(logedin);
}

class SuccessLogoutState extends LoginState {
  SuccessLogoutState(logedout);
}

class LogoutLoadingState extends LoginState {}

class ErrorState extends LoginState {
  String errorMessage;

  ErrorState({required this.errorMessage});
}

class LoginStateInt extends LoginState {}

class LoginStateLoading extends LoginState {}

class LoginSucessState extends LoginState {
  String message;

  LoginSucessState(this.message);
}
