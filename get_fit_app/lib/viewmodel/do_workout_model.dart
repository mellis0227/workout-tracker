import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

class Workouts {
  final String workoutName;
  final String instructions;
  final String difficulty;

  const Workouts({required this.workoutName, required this.difficulty, required this.instructions});
}



class DoWorkoutModel {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Workouts>> getPlaylistData(String playlist, String userID) async {
    List<Workouts> playlistData = [];
    try {
      final workoutData = firestore.collection("user_data/$userID/workout_plans/$playlist/workouts");
      final snapshot = await workoutData.get();
      for(var doc in snapshot.docs){
        final workout = Workouts(
          workoutName: doc.id,
          difficulty: doc.data()["workout_difficulty"],
          instructions: doc.data()["workout_details"],
        );
        playlistData.add(workout);
      }



    } catch(e){
      print(e);
    }
    return playlistData;
  }
}