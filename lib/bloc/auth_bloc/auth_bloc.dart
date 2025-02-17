import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_diary/bloc/model/user.dart';
import 'package:plant_diary/repository/user_repo.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._userRepo) : super(InitAuthState());

  final UserRepo _userRepo;

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is CheckAuthEvent) {
      yield AuthState.loading();
      // perform login
      User user = await _userRepo.getUser();
      if (user != null) {
        yield AuthState.authenticated(user.userId);
      } else {
        yield AuthState.unauthenticated();
      }
    } else if (event is LogInEvent) {
      yield* mapLogInEventToState(event);
    } else if (event is LogOutEvent) {
      yield AuthState.loading();
      // perform logut
      await _userRepo.signOut();
      yield AuthState.unauthenticated();
    }
  }

  /// Perfoming logging in and yieliding apropriate states
  /// It will emit LoadingAuthState at the beginging and
  /// AuthenticatedState when the authentication is completed
  /// or if the user is aleary authenticated and valid
  /// On error AuthErrorState is emited.
  Stream<AuthState> mapLogInEventToState(LogInEvent event) async* {
    yield AuthState.loading();
    // perform login
    User user = await _userRepo.getUser();
    if (user != null) {
      yield AuthState.authenticated(user.userId);
    } else {
      if (event.email?.isEmpty == null || event.password?.isEmpty == null) {
        await Future.delayed(Duration(milliseconds: 300));
        print('username or password is missing');
        yield AuthState.error('Username or password missing.');
      } else {
        print('username and password are present');
        try {
          User user = await _userRepo.login(event.email, event.password);
          yield AuthState.authenticated(user.userId);
        } catch (error) {
          yield AuthState.error(error?.toString() ?? '');
        }
      }
    }
  }

  void login(String email, String password) {
    add(LogInEvent(email, password));
  }

  void logout() {
    add(LogOutEvent());
  }

  void checkAuth() {
    add(CheckAuthEvent());
  }
}
