import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/*
* Fetches API workout data with attributes
*   CHECK DOCUMENTATION TO SEE WHAT CAN BE IMPLEMENTED --> https://www.api-ninjas.com/api/exercises
*
* fetchWorkoutData returns a List<dynamic> of the data from api
* createNewWorkoutPlan passes all the values needed with helper functions to send to database
**/

class WorkoutApiModel {
  // name parameter is the initial title ex: muscle, then parameter matcher is the specific type ex: biceps
  //passed parameters into hyperlink to return data
  // This function fetches workout data based on the provided nameParameter (e.g., 'muscle') and parameterMatcher (e.g., 'biceps')
  Future<List<dynamic>> fetchWorkoutData(
      String nameParameter, String parameterMatcher) async {
    final String apiUrl =
        "https://api.api-ninjas.com/v1/exercises?$nameParameter=$parameterMatcher";
    final String apiKey = "YOUR_API_NINJAS_KEY";

    // Send a GET request to the API with appropriate headers
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
        "x-api-key": apiKey,
        "Content-Type": "application/json",
      },
    );

    // Check if the response status code is 200 (OK), then decode the JSON response and return the data
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      print("Error: ${response.statusCode}");
      // Return an empty list if there's an error
      return [];
    }
  }

  // This function sets the name of the workout plan for a specific user
  // The userID is used to locate the correct user in Firestore, and the planName is the name of the workout plan
  Future<void> setWorkoutPlanName(String userID, String planName) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Reference to the user's workout plan collection in Firestore
      final workoutPlanName =
      firestore.collection('user_data/$userID/workout_plan');
      // Create or update the workout plan document with the specified planName
      await workoutPlanName.doc(planName).set({"plan_name": planName});
    } catch (e) {
      // Handle any errors during the Firestore operation
      print("Error $e : issues setting workout plan name");
    }
  }

  // This function sets the workout details for a specific workout in a user's workout plan
  // It takes the userID, planName, workoutData, and the index of the specific workout to update
  Future<void> setWorkoutDetails(String userID, String planName,
      List<dynamic> workoutData, int index) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Reference to the specific workout collection within the user's workout plan
      final workoutPlan = firestore
          .collection('user_data/$userID/workout_plan')
          .doc(planName)
          .collection("workouts");
      // Set the workout details in Firestore (difficulty and instructions)
      await workoutPlan.doc(workoutData[index]["name"]).set({
        'workout_difficulty': workoutData[index]['difficulty'],
        'workout_details': workoutData[index]['instructions'],
      });
    } catch (e) {
      // Handle any errors during the Firestore operation
      print("Error $e : unable to set workouts within new plan name");
    }
  }

  // This function retrieves all the workout plans for a specific user from Firestore
  // It returns a list of plan names
  Future<List<dynamic>> getWorkoutPlans(String userID) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Reference to the user's workout plans collection
      final workoutPlansCollection =
      firestore.collection('user_data/$userID/workout_plan');

      // Fetch all workout plan documents from Firestore
      final querySnapshot = await workoutPlansCollection.get();
      List<dynamic> planNames = [];
      // Loop through the documents and add the plan names to the list
      for (var doc in querySnapshot.docs) {
        planNames.add(doc["plan_name"]);
      }
      // Return the list of plan names
      return planNames;
    } catch (e) {
      // Handle any errors during the Firestore operation
      print("Error $e: unable to retrieve workout plan names");
      return [];
    }
  }
}
