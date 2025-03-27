import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_fit_app/viewmodel/authentication_user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> authenticate(UserModel user, bool register) async {
    try {
      if (register) {
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password,
        );
      } else {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: user.email,
          password: user.password,
        );
      }
      return _firebaseAuth.currentUser;
    } catch (e) {
      throw Exception('Authentication failed: $e');
    }
  }
}
