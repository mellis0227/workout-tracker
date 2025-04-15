import 'package:get_fit_app/viewmodel/api_model.dart';

// This class acts as a presenter that communicates with the WorkoutApiModel
// It fetches workout data and interacts with the model to perform various actions
class WorkoutAPIPresenter {
  // Creating an instance of the WorkoutApiModel to access its methods
  WorkoutApiModel model = WorkoutApiModel();

  // This function retrieves workout data from the API based on the name and matcher parameters
  // It calls the model's fetchWorkoutData function and returns the data
  Future<List> retrieveWorkoutAPIData(
      String nameParameter, String parameterMatcher) async {
    return await model.fetchWorkoutData(nameParameter, parameterMatcher);
  }

  // This function sets the details of a workout plan in the Firestore database
  // It passes the user ID, plan name, workout data, and the specific index to the model
  Future<void> setWorkoutDetails(String userID, String planName,
      List<dynamic> workoutData, int index) async {
    await model.setWorkoutDetails(userID, planName, workoutData, index);
  }

  // This function fetches all the workout plans for a given user from Firestore
  // It retrieves the data by calling the model's getWorkoutPlans function
  Future<List> getWorkoutPlans(String userID) async {
    return model.getWorkoutPlans(userID);
  }

  // This function sets the workout plan name for the user in Firestore
  // It calls the model's setWorkoutPlanName method to save the plan name
  Future<void> setWorkoutPlanName(String planName, String userID) async {
    await model.setWorkoutPlanName(planName, userID);
  }
}
