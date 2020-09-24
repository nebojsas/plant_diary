abstract class AuthEvent {}

class LogInEvent extends AuthEvent {
  final String email;
  final String password;

  LogInEvent(this.email, this.password);
}

class LogOutEvent extends AuthEvent {}

class CheckAuthEvent extends AuthEvent {}
