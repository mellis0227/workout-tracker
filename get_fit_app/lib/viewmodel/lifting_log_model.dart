import 'package:cloud_firestore/cloud_firestore.dart';

class Exercise {
  String id;
  String exercise;
  int weight;
  int reps;
  int sets;

  Exercise({
    required this.id,
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
List<Exercise> exercises = [];

Future<void> logExercise(String exercise, int weight, int reps,
    int sets) async {
  try {
    await firestore.collection('exercises').add({
      '_exercise': exercise,
      '_weight': weight,
      '_reps': reps,
      '_sets': sets,
    });
  } catch (e) {
    print('Error logging exercise');
  }
}
}