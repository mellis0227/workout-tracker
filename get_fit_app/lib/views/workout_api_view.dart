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
  String? playlistName; // To store the name of a new playlist
  String? selectedPlaylist; // To store the currently selected playlist
  String? user; // To store the current user's email
  List<dynamic> playlistNames = []; // List of workout playlist names
  WorkoutAPIPresenter presenter = WorkoutAPIPresenter(); // Presenter to handle workout data
  List<dynamic> displayedWorkouts = []; // List to hold displayed workout data

  // Fetches workout data based on muscle and difficulty filters and updates the UI
  void _setWorkoutData(String nameParameter, String parameterMatcher) async {
    // Call the presenter to retrieve workout data from the API
    List<dynamic> data =
    await presenter.retrieveWorkoutAPIData(nameParameter, parameterMatcher);
    setState(() {
      displayedWorkouts = data; // Update the state with the fetched data
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
    // Get the user's workout plans from Firestore
    List<dynamic> data = await presenter.getWorkoutPlans(userID);
    setState(() {
      playlistNames = data; // Update the playlist names for the user
    });
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser?.email; // Get the current user's email
    // Fetch the user's playlist names from Firestore using the user email
    _getUsersPlaylistNames(user!);
    // Uncomment to initially fetch workouts by default filter (muscle = "biceps")
    // _setWorkoutData("muscle", "biceps");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent.shade200, // AppBar color
          title: Text(
            "Find Workouts", // Title for the screen
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
                color: Colors.redAccent.shade100, // Container color
              ),
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.all(20)),
                  // Button to filter workouts by muscle and difficulty
                  TextButton(
                    child: Text("Filter",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20)),
                    onPressed: () {
                      // Show the filter dialog
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => showFilters());
                    },
                  ),
                  Padding(padding: EdgeInsets.all(45)),
                  // Button to manage workout playlists
                  TextButton(
                      child: Text("Workout Playlist",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20)),
                      onPressed: () {
                        // Show the playlist management dialog
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
                    displayedWorkouts[index]["name"], // Workout name
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
          "No Workouts Found press filter to find workouts!", // Message when no workouts are found
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
                    onChanged: (value) => {_setWorkoutData('Muscle', value!)} // Set workout data based on muscle
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
                    onChanged: (value) => {_setWorkoutData('Difficulty', value!)} // Set workout data based on difficulty
                ),
              ],
            ))); // Close filter dialog
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
                      selectedPlaylist = newValue; // Update the selected playlist
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
                    playlistName = value; // Update playlist name when user types
                  },
                ),
                // Button to create the new playlist
                ElevatedButton(
                  child: Text("Press to Create Playlist"),
                  onPressed: () => {
                    createPlaylistButton(), // Create the playlist when pressed
                    presenter.getWorkoutPlans("user_test") // Fetch workout plans
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
    presenter.setWorkoutPlanName(user!, playlistName!); // Create playlist using the entered name
    return;
  }
}

