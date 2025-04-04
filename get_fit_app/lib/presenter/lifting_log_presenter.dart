import '../viewmodel/lifting_log_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiftingLogPresenter {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logExercise(Exercise exercise) async {
    await _firestore.collection('exercises').add(exercise.toMap());
  }
}
