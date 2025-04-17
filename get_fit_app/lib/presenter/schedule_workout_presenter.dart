import 'package:get_fit_app/viewmodel/api_model.dart';
import 'package:get_fit_app/viewmodel/schedule_workouts_model.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleWorkoutPresenter {
  WorkoutApiModel playlistModel = WorkoutApiModel();
  ScheduleModel scheduleModel = ScheduleModel();


  Future<List> getPlaylists(String userID) {
    return playlistModel.getWorkoutPlans(userID);
  }


  Future<void> setWeekdayInFirebase(String userID, String playlistName, DateTime currentDate) async {
    return scheduleModel.setWeekdayInFirebase(userID, playlistName, currentDate);
  }


}
