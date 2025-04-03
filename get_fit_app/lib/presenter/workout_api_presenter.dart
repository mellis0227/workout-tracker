
import 'package:get_fit_app/viewmodel/api_model.dart';

class WorkoutAPIPresenter {
  WorkoutApiModel model = WorkoutApiModel();

  Future<List> retrieveWorkoutAPIData(String nameParameter, String parameterMatcher) async {
    return await model.fetchWorkoutData(nameParameter, parameterMatcher);
  }
  Future<void> setWorkoutDetails(String userID, String planName, List<dynamic> workoutData, int index) async {
    await model.setWorkoutDetails(userID, planName, workoutData, index);
  }
  Future<List> getWorkoutPlans(String userID) async {
    return model.getWorkoutPlans(userID);
  }
  Future<void> setWorkoutPlanName(String planName, String userID) async {
    await model.setWorkoutPlanName(planName, userID);
  }
}