abstract class LoginEvent {}

class CheckAuthStatus extends LoginEvent {}

class LoginUser extends LoginEvent {
  final String username;
  final String password;

  LoginUser(this.username, this.password);
}

class LogoutUser extends LoginEvent {}
