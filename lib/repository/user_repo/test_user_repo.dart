import 'package:plant_diary/bloc/model/user.dart';
import 'package:plant_diary/repository/user_repo.dart';

class TestUserRepo extends UserRepo {
  final User _user;
  final String _password;

  TestUserRepo(this._user, this._password);
  @override
  Future<User> getUser() => Future.value(_user);

  @override
  Future<void> signOut() => Future.delayed(Duration(milliseconds: 300));

  @override
  Future<User> login(String email, String password) async {
    if (email != _user.email) throw Error();
    if (password != _password) throw Error();
    return _user;
  }
}
