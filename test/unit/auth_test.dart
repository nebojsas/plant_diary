import 'package:bloc_test/bloc_test.dart';
import 'package:plant_diary/bloc/auth.dart';
import 'package:plant_diary/bloc/model/user.dart';
import 'package:plant_diary/repository/user_repo/test_user_repo.dart';

void main() {
  final testEmail = 'user@example.com';
  final testId = 'userId';
  final testPass = 'password';
  final testName = 'User';

  final testAuthRepo =
      TestUserRepo(User(testId, testEmail, testName), testPass);
  blocTest<AuthBloc, AuthState>('Auth Success',
      build: () => AuthBloc(testAuthRepo),
      act: (bloc) => bloc.login(testEmail, testPass),
      expect: <AuthState>[LoadingAuthState(), AuthenticatedState(testId)]);


  blocTest<AuthBloc, AuthState>('Auth Failed',
      build: () => AuthBloc(testAuthRepo),
      act: (bloc) => bloc.login(testEmail, 'wrongPass'),
      expect: <AuthState>[LoadingAuthState(), AuthErrorState(null)]);
}
