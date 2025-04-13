import 'package:cloud_firestore/cloud_firestore.dart';

// Exercise class to represent individual exercise data
class Exercise {
  String id;
  String exercise;
  int weight;
  int reps;
  int sets;

  // Constructor to initialize the exercise details
  Exercise(
      {required this.id,
        required this.exercise,
        required this.weight,
        required this.reps,
        required this.sets});

  // Converts the exercise object to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'exercise': exercise,
      'weight': weight,
      'sets': sets,
      'reps': reps,
    };
  }
}

class LiftingLogModel {
  final FirebaseFirestore firestore = FirebaseFirestore.instance; // Instance of Firestore
  LiftingLogModel();

  // List to store exercise records
  List<Exercise> exercises = [];

  // Logs a new exercise into Firestore
  Future<void> logExercise(
      String exercise, int weight, int reps, int sets) async {
    try {
      // Adding exercise data to Firestore under the 'exercises' collection
      await firestore.collection('exercises').add({
        '_exercise': exercise,
        '_weight': weight,
        '_reps': reps,
        '_sets': sets,
      });
    } catch (e) {
      print('Error logging exercise'); // Catching and logging any errors
    }
  }
}
