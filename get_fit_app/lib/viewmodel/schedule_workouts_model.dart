import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_fit_app/presenter/schedule_workout_presenter.dart';


class ScheduleModel {
  DateTime? scheduledTime;
  String? currentPlaylistName;
  static const Map<int, String> weekDayNames = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday"
  };

  String? determineWeekDayName(int weekNumber) {
    if(!weekDayNames.containsKey(weekNumber)) {
      throw ArgumentError("Broo this aint a week day");
    }
    return weekDayNames[weekNumber];
  }

  Future<void> setWeekdayInFirebase(String userID, String playlistName, DateTime currentDate) async {
    try{
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final workoutPlan = firestore.doc('user_data/$userID/workout_plans/$playlistName');
      print("added to $userID $playlistName");

      await workoutPlan.set({
        "week_day": determineWeekDayName(currentDate.weekday),
      });

    }catch(e){
      print("Failed to set $currentDate within database");
    }
  }



}