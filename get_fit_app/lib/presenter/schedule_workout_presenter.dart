import 'package:get_fit_app/viewmodel/api_model.dart';
import 'package:get_fit_app/viewmodel/schedule_workouts_model.dart';

class ScheduleWorkoutPresenter {
  WorkoutApiModel playlistModel = WorkoutApiModel();
  ScheduleModel? scheduleModel;

  Future<List> getPlaylists(String userID) {
    return playlistModel.getWorkoutPlans(userID);
  }


}
