import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_fit_app/presenter/workout_api_presenter.dart';


class WorkoutAPIScreen extends StatefulWidget {
  const WorkoutAPIScreen({super.key});

  @override
  _WorkoutAPIScreenState createState() => _WorkoutAPIScreenState();
}

class _WorkoutAPIScreenState extends State<WorkoutAPIScreen> {
  String? playlistName;
  String? selectedPlaylist;
  String? username;
  List<dynamic> playlistNames = [];
  WorkoutAPIPresenter presenter = WorkoutAPIPresenter();
  List<dynamic> displayedWorkouts = [];

  void _setWorkoutData(String nameParameter, String parameterMatcher) async {
    List<dynamic> data =
        await presenter.retrieveWorkoutAPIData(nameParameter, parameterMatcher);
    setState(() {
      displayedWorkouts = data;
    });

    List<String> printedCats = ["name", "type", "difficulty"];
    for (int i = 0; i < displayedWorkouts.length; i++) {
      for (int j = 0; j < printedCats.length; j++) {
        print(displayedWorkouts[i][printedCats[j]]);
      }
    }
  }

  void _getUsersPlaylistNames(String userID) async {
    List<dynamic> data = await presenter.getWorkoutPlans(userID);
    setState(() {
      playlistNames = data;
    });
  }

  @override
  void initState() {
    super.initState();
    username = FirebaseAuth.instance.currentUser?.email;
    _getUsersPlaylistNames(username!);
    // _setWorkoutData("muscle", "biceps");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent.shade200,
          title: Text(
            "Find Workouts",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
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
                    child: Text("Filter",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => showFilters());
                    },
                  ),
                  Padding(padding: EdgeInsets.all(45)),
                  TextButton(
                      child: Text("Workout Playlist",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20)),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => showPlaylist());
                      })
                ],
              ),
            ),
            Expanded(
              child: _buildWorkoutList(),
            ),
          ],
        ));
  }

  ListView _buildWorkoutList() {
    if (displayedWorkouts.isNotEmpty) {
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
                      "Difficulty ${displayedWorkouts[index]['difficulty']}\n"),
                  trailing: TextButton(
                    child: Text("View Instructions"),
                    onPressed: () => {viewInstructionContainer(context, index)},
                  ),
                  leading: TextButton(
                    child: Text("Save"),
                    onPressed: () => {},
                  ),
                ));
          });
    }
    return ListView(
      children: [
        Text(
          "No Workouts Found press filter to find workouts!",
          style: TextStyle(fontSize: 40),
        ),
      ],
    );
  }

  AlertDialog showFilters() {
    return AlertDialog(
        title: Text("Filter by"),
        content: SizedBox(
            height: 150,
            child: Column(
              children: [
                DropdownButton(
                  hint: Text("Muscle"),
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(
                      value: "Biceps",
                      child: Text("Biceps"),
                    ),
                    DropdownMenuItem(
                      value: "Chest",
                      child: Text("Chest"),
                    ),
                    DropdownMenuItem(
                      value: "Lats",
                      child: Text("Lats"),
                    ),
                  ],
                  onChanged: (value) => {_setWorkoutData('Muscle', value!)},
                ),
                DropdownButton(
                  hint: Text("Difficulty"),
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(
                      value: "Beginner",
                      child: Text("Beginner"),
                    ),
                    DropdownMenuItem(
                      value: "Intermediate",
                      child: Text("Intermediate"),
                    ),
                    DropdownMenuItem(
                      value: "Expert",
                      child: Text("Expert"),
                    ),
                  ],
                  onChanged: (value) => {_setWorkoutData('Difficulty', value!)},
                ),
              ],
            )));
  }

  AlertDialog showPlaylist() {
    return AlertDialog(
        title: Text("Workout Playlist"),
        content: SizedBox(
            height: 150,
            child: Column(
              children: [
                DropdownButton<String>(
                  hint: Text("Select Playlist"),
                  isExpanded: true,
                  value: selectedPlaylist,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPlaylist = newValue;
                    });
                  },
                  items: playlistNames
                      .map<DropdownMenuItem<String>>((dynamic playlist) {
                    return DropdownMenuItem<String>(
                      value: playlist,
                      child: Text(playlist),
                    );
                  }).toList(),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Name New Playlist",
                  ),
                  onChanged: (value) {
                    playlistName = value;
                  },
                ),
                ElevatedButton(
                  child: Text("Press to Create Playlist"),
                  onPressed: () => {
                    createPlaylistButton(),
                    presenter.getWorkoutPlans("user_test")
                  },
                ),
              ],
            )));
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
            ));
      },
      isScrollControlled: true,
    );
  }

  void createPlaylistButton() {
    presenter.setWorkoutPlanName("user_test", playlistName!);
    return;
  }
}
