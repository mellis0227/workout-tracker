import 'package:cloud_firestore/cloud_firestore.dart';


class ScheduleModel {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> setWeekdayInFirebase(String userID, String playlistName, String dayOfWeek) async {
    try{
      final workoutPlan = firestore.collection('user_data/$userID/workout_schedule');
      DocumentReference docRef = workoutPlan.doc(dayOfWeek);
      DocumentSnapshot snapshot = await docRef.get();
     if(!snapshot.exists) {
       await workoutPlan.doc(dayOfWeek).set({
         "day": dayOfWeek,
         "playlist": [playlistName],
       });
     } else{
        await docRef.update({
          "playlist": FieldValue.arrayUnion([playlistName]),
        });
     }

    }catch(e){
      print("Failed to set $playlistName on $dayOfWeek within database");
    }
  }

  //builds a map of weekday: list of playlists within the weekday to populate page, think of a better way lol
  Future<Map<String, List<dynamic>>> buildScheduleMapFromFirebase(String userID) async {
    Map<String, List<dynamic>> mappedSchedule = {
      "Monday": [],
      "Tuesday": [],
      "Wednesday": [],
      "Thursday": [],
      "Friday": [],
      "Saturday": [],
      "Sunday": [],
    };
    try{
      final workoutPlan = firestore.collection('user_data/$userID/workout_schedule');
      final weekdaySnapshot = await workoutPlan.get();


      for(var doc in weekdaySnapshot.docs) {
        final weekDay = doc.id;
        final listOfPlaylists = doc.data()["playlist"];
        mappedSchedule[weekDay] = listOfPlaylists;

      }
      return mappedSchedule;

    } catch(e) {
      print("Failed to build map");
      return {};
    }
  }

  Future<void> removeSelectedPlaylist(String userID, String playlistName, String dayOfWeek) async {
    try{
      final workoutPlan = firestore.collection('user_data/$userID/workout_schedule');
      DocumentReference docRef = workoutPlan.doc(dayOfWeek);
      DocumentSnapshot snapshot = await docRef.get();

      await docRef.update({
        "playlist": FieldValue.arrayRemove([playlistName]),
      });


    }catch(e){
      print("Failed to remove $playlistName on $dayOfWeek within database");
    }
  }

}