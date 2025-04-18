import 'package:cloud_firestore/cloud_firestore.dart';



class ScheduleModel {

  Future<void> setWeekdayInFirebase(String userID, String playlistName, String dayOfWeek) async {
    try{
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final workoutPlan = firestore.doc('user_data/$userID/workout_plans/$playlistName');
      print("added to $userID $playlistName");

      await workoutPlan.set({
        "week_day": dayOfWeek,
      }, SetOptions(merge: true));

    }catch(e){
      print("Failed to set $dayOfWeek within database");
    }
  }



}