abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginAuthenticated extends LoginState {
  final String token;
  final String username;

  LoginAuthenticated(this.token, this.username);
}

class LoginUnauthenticated extends LoginState {}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);
}
