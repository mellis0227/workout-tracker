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
      final workoutData = firestore.collection("user_data/$userID/workout_plans/$playlist");
      final snapshot = await workoutData.get();

      for(var doc in snapshot.docs){
        final workout = Workouts(
          workoutName: doc.id,
          difficulty: doc["difficulty"] ?? "No Difficulty Listed",
          instructions: doc["instructions"] ?? "No Instructions Listed",
        );
        playlistData.add(workout);
      }


    } catch(e){
      print(e);
    }
    return playlistData;
  }
}