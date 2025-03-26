import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
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
  Future<List<dynamic>> fetchWorkoutData(String nameParameter, String parameterMatcher) async {
    final String apiUrl = "https://api.api-ninjas.com/v1/exercises?$nameParameter=$parameterMatcher";
    final String apiKey = "YOUR_API_NINJAS_KEY";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
        "x-api-key": apiKey,
        "Content-Type": "application/json",
      },
    );

    if(response.statusCode == 200){
      var data = json.decode(response.body);
      return data;
    } else {
      print("Error: ${response.statusCode}");
      return [];
    }
  }

  Future<void> createNewWorkoutPlan(String userID, String planName, String workoutName, String workoutDifficulty, String workoutDetails) async {
    try{
      await setWorkoutPlanName(planName, userID);
     // Future.delayed(Duration(seconds: 1));
      await setWorkoutDetails(userID, planName, workoutName, workoutDifficulty, workoutDetails);

    } catch (e){
      print("Error $e : issues creating entire workout plan");
    }
  }

  Future<void> setWorkoutPlanName(String planName, String userID) async {
    try{
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection("user_data").doc(userID).collection("workout_plan").doc(planName).set({
        'plan_name': planName,
      });
    } catch (e){
      print("Error $e : issues setting workout plan name");
    }
  }

  Future<void> setWorkoutDetails(String userID, String planName, String workoutName, String workoutDifficulty, String workoutDetails) async {
    try{
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection('user_data').doc(userID).collection('workout_plan').doc(planName).collection("workouts").doc(workoutName).set({
        'workout_difficulty': workoutDifficulty,
        'workout_details': workoutDetails,
      });
    } catch(e) {
      print("Error $e : unable to set workouts within new plan name");
    }
  }


}



