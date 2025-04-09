import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/*
* Fetches API workout data with attributes
*   CHECK DOCUMENTATION TO SEE WHAT CAN BE IMPLEMENTED --> https://www.api-ninjas.com/api/exercises
*
*
* fetchWorkoutData returns a List<dynamic> of the data from api
* createNewWorkoutPlan passes all the values needed with helper functions to send to database
**/
class WorkoutApiModel {
  // name parameter is the initial title ex: muscle, then parameter matcher is the specific type ex: biceps
  //passed parameters into hyperlink to return data
  Future<List<dynamic>> fetchWorkoutData(
      String nameParameter, String parameterMatcher) async {
    final String apiUrl =
        "https://api.api-ninjas.com/v1/exercises?$nameParameter=$parameterMatcher";
    final String apiKey = "YOUR_API_NINJAS_KEY";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
        "x-api-key": apiKey,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      print("Error: ${response.statusCode}");
      return [];
    }
  }

  Future<void> setWorkoutPlanName(String userID, String planName) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final workoutPlanName =
          firestore.collection('user_data/$userID/workout_plan');
      await workoutPlanName.doc(planName).set({"plan_name": planName});
    } catch (e) {
      print("Error $e : issues setting workout plan name");
    }
  }

  Future<void> setWorkoutDetails(String userID, String planName,
      List<dynamic> workoutData, int index) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final workoutPlan = firestore
          .collection('user_data/$userID/workout_plan')
          .doc(planName)
          .collection("workouts");
      await workoutPlan.doc(workoutData[index]["name"]).set({
        'workout_difficulty': workoutData[index]['difficulty'],
        'workout_details': workoutData[index]['instructions'],
      });
    } catch (e) {
      print("Error $e : unable to set workouts within new plan name");
    }
  }

  Future<List<dynamic>> getWorkoutPlans(String userID) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final workoutPlansCollection =
          firestore.collection('user_data/$userID/workout_plan');

      final querySnapshot = await workoutPlansCollection.get();
      List<dynamic> planNames = [];
      for (var doc in querySnapshot.docs) {
        planNames.add(doc["plan_name"]);
      }
      return planNames;
    } catch (e) {
      print("Error $e: unable to retrieve workout plan names");
      return [];
    }
  }
}
