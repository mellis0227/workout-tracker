import '../viewmodel/lifting_log_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiftingLogPresenter {
  // Instance of FirebaseFirestore for interacting with Firestore database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Logs an exercise to the Firestore database
  Future<void> logExercise(Exercise exercise) async {
    // Adds the exercise data to the 'exercises' collection in Firestore
    await _firestore.collection('exercises').add(exercise.toMap());
  }
}
