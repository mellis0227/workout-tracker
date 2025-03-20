import 'package:http/http.dart' as http;
import 'dart:convert';
/*
* Fetches API workout data with attributes
*   CHECK DOCUMENTATION TO SEE WHAT CAN BE IMPLEMENTED --> https://www.api-ninjas.com/api/exercises
*
*
* fetchWorkoutData returns a List<dynamic> of that data
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



}



