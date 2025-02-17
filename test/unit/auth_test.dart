import 'package:bloc_test/bloc_test.dart';
import 'package:plant_diary/bloc/auth.dart';
import 'package:plant_diary/bloc/model/user.dart';
import 'package:plant_diary/repository/user_repo/test_user_repo.dart';

void main() {
  final testEmail = 'test_user@example.com';
  final testId = 'testUserId';
  final testPass = 'testPassword';
  final testName = 'Test User';

  final testAuthRepo = TestUserRepo(
      User(userId: testId, email: testEmail, name: testName), testPass);
  blocTest<AuthBloc, AuthState>('Auth Success',
      build: () => AuthBloc(testAuthRepo),
      act: (bloc) => bloc.login(testEmail, testPass),
      expect: <AuthState>[
        AuthState.loading(),
        AuthState.authenticated(testId)
      ]);

  blocTest<AuthBloc, AuthState>('Auth Failed',
      build: () => AuthBloc(testAuthRepo),
      act: (bloc) => bloc.login(null, null),
      expect: <AuthState>[
        AuthState.loading(),
        AuthState.error('Username or password missing.')
      ]);
}
