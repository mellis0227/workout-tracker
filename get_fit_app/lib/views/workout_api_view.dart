import 'package:flutter/material.dart';
import 'package:get_fit_app/presenter/workout_api_presenter.dart';

class WorkoutAPIScreen extends StatefulWidget {
  const WorkoutAPIScreen({super.key});

  @override
  _WorkoutAPIScreenState createState() => _WorkoutAPIScreenState();
}

class _WorkoutAPIScreenState extends State<WorkoutAPIScreen> {
  WorkoutAPIPresenter presenter = WorkoutAPIPresenter();
  List<dynamic> displayedWorkouts = [];

  void _setWorkoutData(String nameParameter, String parameterMatcher) async {
    List<dynamic> data = await presenter.retrieveWorkoutAPIData(nameParameter, parameterMatcher);
    setState(() {
      displayedWorkouts = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _setWorkoutData("muscle", "biceps");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade100,
        title: Text("Find Workouts", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Container(
            width: 500,
            height: 75,
            color: Colors.greenAccent.shade100,
            child: Row(
              children: [

              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: displayedWorkouts.length,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                      elevation: 5,
                      shadowColor: Colors.redAccent.shade400,
                      child: ListTile(
                        tileColor: Colors.grey.shade100,
                        title: Text(
                            displayedWorkouts[index]["name"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            "Muscle: ${displayedWorkouts[index]["muscle"]}\n"
                            "Instructions: ${displayedWorkouts[index]["instructions"]}\n"
                        ),
                      )
                  );
                }
            ),
          ),
        ],
      )
    );
  }
}
