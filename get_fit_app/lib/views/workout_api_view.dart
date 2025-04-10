import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_fit_app/presenter/workout_api_presenter.dart';

// This screen allows users to interact with workout API and manage their workout playlists.
class WorkoutAPIScreen extends StatefulWidget {
  const WorkoutAPIScreen({super.key});

  @override
  _WorkoutAPIScreenState createState() => _WorkoutAPIScreenState();
}

class _WorkoutAPIScreenState extends State<WorkoutAPIScreen> {
  String? playlistName;
  String? selectedPlaylist;
  String? user;
  List<dynamic> playlistNames = [];
  WorkoutAPIPresenter presenter = WorkoutAPIPresenter();
  List<dynamic> displayedWorkouts = [];

  // Fetches workout data based on muscle and difficulty filters and updates the UI
  void _setWorkoutData(String nameParameter, String parameterMatcher) async {
    List<dynamic> data =
        await presenter.retrieveWorkoutAPIData(nameParameter, parameterMatcher);
    setState(() {
      displayedWorkouts = data;
    });

    // Print the selected workout data attributes (name, type, difficulty) to the console
    List<String> printedCats = ["name", "type", "difficulty"];
    for (int i = 0; i < displayedWorkouts.length; i++) {
      for (int j = 0; j < printedCats.length; j++) {
        print(displayedWorkouts[i][printedCats[j]]);
      }
    }
  }

  // Fetches the list of workout playlist names for the current user
  void _getUsersPlaylistNames(String userID) async {
    List<dynamic> data = await presenter.getWorkoutPlans(userID);
    setState(() {
      playlistNames = data;
    });
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser?.email;
    // Fetch the user's playlist names from Firestore using the user email
    _getUsersPlaylistNames(user!);
    // Uncomment to initially fetch workouts by default filter (muscle = "biceps")
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
            // Header with buttons for filtering and managing workout playlists
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
            // Display the list of workouts
            Expanded(
              child: _buildWorkoutList(),
            ),
          ],
        ));
  }

  // Builds the workout list view
  ListView _buildWorkoutList() {
    // If there are workouts, display them in a list, otherwise show a message
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

  // Displays the filter options in a dialog for selecting muscle and difficulty
  AlertDialog showFilters() {
    return AlertDialog(
        title: Text("Filter by"),
        content: SizedBox(
            height: 150,
            child: Column(
              children: [
                // Dropdown to select muscle type (e.g., biceps, chest)
                DropdownButton<String>(
                  hint: Text("Muscle"),
                  isExpanded: true,
                  items:
                      <String>['Biceps', 'Chest', 'lats'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) => {_setWorkoutData('Muscle', value!)},
                ),
                // Dropdown to select workout difficulty (e.g., Beginner, Intermediate)
                DropdownButton<String>(
                  hint: Text("Difficulty"),
                  isExpanded: true,
                  items: <String>['Beginner', 'Intermediate', 'Expert']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) => {_setWorkoutData('Difficulty', value!)},
                ),
              ],
            )));
  }

  // Displays the workout playlist options in a dialog
  AlertDialog showPlaylist() {
    return AlertDialog(
        title: Text("Workout Playlist"),
        content: SizedBox(
            height: 150,
            child: Column(
              children: [
                // Dropdown to select a playlist
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
                // TextField to create a new playlist by name
                TextField(
                  decoration: InputDecoration(
                    hintText: "Name New Playlist",
                  ),
                  onChanged: (value) {
                    playlistName = value;
                  },
                ),
                // Button to create the new playlist
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

  // Show the instructions for a selected workout in a bottom sheet
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

  // Create a new workout playlist for the user
  void createPlaylistButton() {
    presenter.setWorkoutPlanName(user!, playlistName!);
    return;
  }
}
