import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_fit_app/viewmodel/authentication_user_model.dart';

// Service class that handles authentication logic using Firebase.
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> setUserInDatabase(UserModel user) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userCollection = firestore.collection("user_data").doc(user.email);

    if(user.firstName != null && user.lastName != null){
      await userCollection.set({
        "email": user.email,
        "first_name": user.firstName,
        "last_name": user.lastName,
      });
    } else {
      await userCollection.set({
        "email": user.email,
      });
    }
  }

  // Method to authenticate the user either via login or registration.
  Future<User?> authenticate(UserModel user, bool register) async {
    try {
      if (register) {
        // Register the user with email and password.
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password,
        );
      } else {
        // Login the user with email and password.
        await _firebaseAuth.signInWithEmailAndPassword(
          email: user.email,
          password: user.password,
        );
      }
      return _firebaseAuth.currentUser; // Return the current logged-in user.
    } catch (e) {
      // If an error occurs, throw an exception with the error message.
      throw Exception('Authentication failed: $e');
    }
  }
}
