import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_diary/bloc/model/user.dart' as PlantDiary;
import 'package:plant_diary/repository/user_repo.dart';

class FirestoreUserRepo extends UserRepo {
  @override
  Future<PlantDiary.User> getUser() async {
    User firestoreUser = FirebaseAuth.instance.currentUser;
    if (firestoreUser == null) return null;
    return PlantDiary.User(
      firestoreUser.uid,
      firestoreUser.displayName,
      firestoreUser.email,
    );
  }

  @override
  Future<void> signOut() => FirebaseAuth.instance.signOut();

  @override
  Future<PlantDiary.User> login(String email, String password) async {
    UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    User firestoreUser = credential.user;
    if (firestoreUser == null) throw Error();
    return PlantDiary.User(
      firestoreUser.uid,
      firestoreUser.displayName,
      firestoreUser.email,
    );
  }
}
