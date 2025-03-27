
import 'package:get_fit_app/viewmodel/api_model.dart';

class WorkoutAPIPresenter {
  WorkoutApiModel model = WorkoutApiModel();

  Future<List> retrieveWorkoutAPIData(String nameParameter, String parameterMatcher) async {
    return await model.fetchWorkoutData(nameParameter, parameterMatcher);
  }

  void createWorkoutPlan(String userID, String planName, String workoutName, String workoutDifficulty, String workoutDetails) async {
    await model.createNewWorkoutPlan(userID, planName, workoutName, workoutDifficulty, workoutDetails);
  }
  void createWorkoutPlanName(String userID, String planName)async{
    await model.setWorkoutPlanName(planName, userID);
  }
  void retrievePlaylistName(String userID) async {
    await model.retrievePlaylistNames(userID);
  }
}