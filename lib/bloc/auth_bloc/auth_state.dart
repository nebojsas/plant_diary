import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  const AuthState._();

  @override
  List<Object> get props => [];

  factory AuthState.init() = InitAuthState;
  factory AuthState.loading() = LoadingAuthState;
  factory AuthState.authenticated(String userId) = AuthenticatedState;
  factory AuthState.unauthenticated() = UnAuthenticatedState;
  factory AuthState.error(String errorMessage) = AuthErrorState;
}

class InitAuthState extends AuthState {
  const InitAuthState() : super._();
}

class LoadingAuthState extends AuthState {
  const LoadingAuthState() : super._();
}

class UnAuthenticatedState extends AuthState {
  const UnAuthenticatedState() : super._();
}

class AuthErrorState extends AuthState {
  final String errorMessage;

  const AuthErrorState(this.errorMessage) : super._();

  @override
  List<Object> get props => [errorMessage];
}

class AuthenticatedState extends AuthState {
  final String userId;

  const AuthenticatedState(this.userId) : super._();

  @override
  List<Object> get props => [userId];
}
