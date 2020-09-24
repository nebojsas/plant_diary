import 'package:plant_diary/bloc/model/user.dart';

abstract class UserRepo {
  Future<User> getUser();
  Future<void> signOut();
  Future<User> login(String email, String password);
}
