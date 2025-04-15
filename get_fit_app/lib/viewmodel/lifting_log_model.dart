import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  String userID;
  String exercise;
  int weight;
  int reps;
  int sets;

  Exercise({
    required this.userID,
    required this.exercise,
    required this.weight,
    required this.reps,
    required this.sets});

  Map<String, dynamic> toMap(){
    return {
      'exercise': exercise,
      'weight': weight,
      'sets': sets,
      'reps': reps,
    };
  }
  }

class LiftingLogModel {
final FirebaseFirestore firestore = FirebaseFirestore.instance;
LiftingLogModel();
List<Exercise> liftingLog = [];

Future<void> logExercise({
  required String userID,
  required String exercise,
  required int weight,
  required int reps,
  required int sets,
}) async {
  try {
    await firestore
        .collection('user_data')
        .doc(userID)
        .collection('lifts')
        .add({
      'exercise': exercise,
      'weight': weight,
      'sets': sets,
      'reps': reps,
    });

  } catch (e) {
    print('Error logging exercise: $e');
  }
}
}