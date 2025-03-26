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

    List<String> printedCats = ["name", "type", "difficulty"];
    for(int i = 0; i < displayedWorkouts.length; i++){
      for(int j = 0; j< printedCats.length; j++) {
        print(displayedWorkouts[i][printedCats[j]]);
      }
    }
  }

  @override
  void initState() {
    super.initState();
   // _setWorkoutData("muscle", "biceps");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent.shade200,
          title: Text("Find Workouts",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              width: 425,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.redAccent.shade100,
              ),
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.all(20)),
                  TextButton(
                    child: Text("Filter", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
                    onPressed: () {
                      showDialog(context: context, builder: (BuildContext context) => showFilters());
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildWorkoutList(),
            ),
          ],
        )
    );
  }

  ListView _buildWorkoutList() {
    if(displayedWorkouts.isNotEmpty) {
      return ListView.builder(
          itemCount: displayedWorkouts.length,
          itemBuilder: (BuildContext context, index) {
            return Card(
                elevation: 5,
                shadowColor: Colors.black26,
                child: ListTile(
                  tileColor: Colors.grey.shade100,
                  title: Text(
                    displayedWorkouts[index]["name"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Muscle: ${displayedWorkouts[index]["muscle"]}\n"
                          "Type: ${displayedWorkouts[index]["type"]}\n"
                          "Difficulty ${displayedWorkouts[index]['difficulty']}\n"
                  ),
                  trailing: TextButton(
                    child: Text("view instructions"),
                    onPressed: () => {
                      viewInstructionContainer(context, index)
                    },
                  ),
                )
            );
          }
      );
    }
    return ListView(
      children: [
        Text("No Workouts Found press filter to find workouts!", style: TextStyle(fontSize: 40),),
      ],
    );
  }

  AlertDialog showFilters() {
    return AlertDialog(
        title: Text("filter by"),
        content: SizedBox(
          height: 150,
          child: Column(
            children: [
              DropdownButton(
                hint: Text("Muscle"),
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                    value: "biceps",
                    child: Text("biceps"),
                  ),
                  DropdownMenuItem(
                    value: "chest",
                    child: Text("chest"),
                  ),
                  DropdownMenuItem(
                    value: "lats",
                    child: Text("lats"),
                  ),
                ],
                onChanged: (value) => {
                  _setWorkoutData('muscle', value!)
                },
              ),

              DropdownButton(
                hint: Text("Difficulty"),
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                    value: "beginner",
                    child: Text("beginner"),
                  ),
                  DropdownMenuItem(
                    value: "intermediate",
                    child: Text("intermediate"),
                  ),
                  DropdownMenuItem(
                    value: "expert",
                    child: Text("expert"),
                  ),
                ],
                onChanged: (value) => {
                  _setWorkoutData('difficulty', value!)
                },
              ),
            ],
          )
        )
    );
  }

  void viewInstructionContainer(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 450,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Instructions"),
                  Text(displayedWorkouts[index]["instructions"]),
                ],
              ),
            )
          );
        },
        isScrollControlled: true,
    );
  }
}
