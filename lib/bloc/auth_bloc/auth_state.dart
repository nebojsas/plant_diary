import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class InitAuthState extends AuthState {
  const InitAuthState();
}

class LoadingAuthState extends AuthState {
  const LoadingAuthState();
}

class UnAuthenticatedState extends AuthState {
  const UnAuthenticatedState();
}

class AuthErrorState extends AuthState {
  final String errorMessage;

  const AuthErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class AuthenticatedState extends AuthState {
  final String userId;

  const AuthenticatedState(this.userId);

  @override
  List<Object> get props => [userId];
}
