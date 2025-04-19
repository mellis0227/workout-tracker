import 'package:get_fit_app/viewmodel/api_model.dart';
import 'package:get_fit_app/viewmodel/schedule_workouts_model.dart';

class ScheduleWorkoutPresenter {
  WorkoutApiModel playlistModel = WorkoutApiModel();
  ScheduleModel scheduleModel = ScheduleModel();


  Future<List> getPlaylists(String userID) {
    return playlistModel.getWorkoutPlans(userID);
  }


  Future<void> setWeekdayInFirebase(String userID, String playlistName, String dayOfWeek) async {
    scheduleModel.buildScheduleMapFromFirebase(userID);
    return scheduleModel.setWeekdayInFirebase(userID, playlistName, dayOfWeek);
  }

  Future<Map<String, List<dynamic>>> populateScheduleMap(String userID) async {
    return scheduleModel.buildScheduleMapFromFirebase(userID);
  }

  String formatScheduleSubtext(List<dynamic> key) {
    if(key.isEmpty){
      return "Off Day";
    } else {
      return "Planned!";
    }

  }

}
