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
  int? selectedWorkoutIndex;
  String? playlistName;
  String? selectedPlaylist;
  String? user;
  List<dynamic> playlistNames = [];
  WorkoutAPIPresenter presenter = WorkoutAPIPresenter();
  List<dynamic> displayedWorkouts = [];
  List<dynamic> selectedWorkouts = [];
  String whatMainPage = "none";

  // Fetches workout data based on muscle and difficulty filters and updates the UI
  void _setWorkoutData(String nameParameter, String parameterMatcher) async {
    // Call the presenter to retrieve workout data from the API
    List<dynamic> data =
        await presenter.retrieveWorkoutAPIData(nameParameter, parameterMatcher);
    setState(() {
      displayedWorkouts = data;// Update the state with the fetched data
      whatMainPage = "filter";
    });
  }

  void _getSelectedWorkoutData(playlist, userID) async{
    List<dynamic> data = await presenter.retrieveUserPlaylistData(playlist, userID);
    setState(() {
      selectedWorkouts = data;
      whatMainPage = "selection";
    });
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
    user = FirebaseAuth
        .instance.currentUser?.email; // Get the current user's email
    // Fetch the user's playlist names from Firestore using the user email
    _getUsersPlaylistNames(user!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        // Header with buttons for filtering and managing workout playlists
        Container(
          width: 425,
          height: 45,
          decoration: BoxDecoration(
            color: Color(0xFFAEC3B0),
          ),
          child: Row(
            children: [
              Padding(padding: EdgeInsets.all(15)),
              // Button to filter workouts by muscle and difficulty
              TextButton(
                child: Text("Filter",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF124559),
                        fontSize: 15)),
                onPressed: () {
                  // Show the filter dialog
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => showFilters());
                },
              ),
              Padding(padding: EdgeInsets.all(5)),
              TextButton(
                child: Text("Select Playlist",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF124559),
                      fontSize: 15)),

                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => playlistSelectionScreen()
                    );
                  }
                ),


              Padding(padding: EdgeInsets.all(5)),
              // Button to manage workout playlists
              TextButton(
                  child: Text("Create Playlist",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF124559),
                          fontSize: 15)),
                  onPressed: () {
                    // Show the playlist management dialog
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => playListCreationScreen());
                  })
            ],
          ),
        ),
        // Display the list of workouts
        Expanded(
          child:
           _getMainPageWidget(),
        ),
      ],
    ));
  }

  Widget _getMainPageWidget() {
    switch (whatMainPage) {
      case 'filter':
        return _buildWorkoutList();
      case 'selection':
        return _buildSelectedPlaylistWorkoutsView();
      default:
        Text("");
        return Center(child: Text(''));
    }
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
                shadowColor: Color(0xFF01161E),
                child: ListTile(
                  tileColor: Color(0xFFEFF6E0),
                  title: Text(
                    displayedWorkouts[index]["name"], // Workout name
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Muscle: ${displayedWorkouts[index]["muscle"]}\n"
                      "Type: ${displayedWorkouts[index]["type"]}\n"
                      "Difficulty ${displayedWorkouts[index]['difficulty']}\n"),
                  trailing: TextButton(
                    child: Text("View Instructions",
                        style: TextStyle(color: Colors.black)),
                    onPressed: () => {viewInstructionContainer(context, index)},
                  ),
                  leading: TextButton(
                    child: Text("Save", style: TextStyle(color: Colors.black)),
                    onPressed: () => {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              savePlaylist(index)),
                    },
                  ),
                ));
          });
    }
    return ListView();
  }
  ListView _buildSelectedPlaylistWorkoutsView(){
    if(selectedWorkouts.isNotEmpty){
      return ListView.builder(
        itemCount: selectedWorkouts.length,
        itemBuilder: (BuildContext context, index){

          return Card(
            elevation: 5,
            shadowColor: Color(0xFF01161E),
            child: ListTile(
              tileColor: Color(0xFFEFF6E0),
              title: Text(
                selectedWorkouts[index].name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              subtitle: Text(
                  //"Muscle: ${selectedWorkouts[index].muscle_group}\n"
                  //"Type: ${selectedWorkouts[index].type}\n"
                  //"Instructions ${selectedWorkouts[index].workout_details}\n"
                  "Difficulty ${selectedWorkouts[index].difficulty}\n"
                ),
              ),
            );
          }
        );
    }
    return ListView();
  }

   void viewSelectedPlaylist(){
    if(selectedPlaylist == null) {
      Text(
        "No Workouts Found press filter to find workouts!",
        // Message when no workouts are found
        style: TextStyle(fontSize: 40),
      );
    }
    else{
      Text("Selected Playlist: " + selectedPlaylist!, style: TextStyle(fontSize: 26));
    }
      return;
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
                DropdownButtonFormField<String>(
                  hint: Text("Muscle", style: TextStyle(color: Colors.black)),
                  isExpanded: true,
                  items:
                      <String>['Biceps', 'Chest', 'Lats'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value.toLowerCase(),
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) => {_setWorkoutData('muscle', value!)},
                ),
                // Dropdown to select workout difficulty (e.g., Beginner, Intermediate)
                DropdownButtonFormField<String>(
                  hint:
                      Text("Difficulty", style: TextStyle(color: Colors.black)),
                  isExpanded: true,
                  items: <String>['Beginner', 'Intermediate', 'Expert']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value.toLowerCase(),
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) => {_setWorkoutData('difficulty', value!)},
                ),
              ],
            ))); // Close filter dialog
  }

  // Displays the workout playlist options in a dialog
  AlertDialog playListCreationScreen() {
    return AlertDialog(
        title: Text("Create Playlist"),
        content: SizedBox(
          height: 100,
          child: StatefulBuilder(builder: (context, StateSetter setState) {
            return Column(
              children: [
                // TextField to create a new playlist by name
                TextField(
                  decoration: InputDecoration(
                    hintText: "Name New Playlist",
                  ),
                  onChanged: (value) {
                    playlistName =
                        value; // Update playlist name when user types
                  },
                ),
                // Button to create the new playlist
                ElevatedButton(
                  child: Text("Press to Create Playlist"),
                  onPressed: () => {
                    createPlaylistButton(),
                    presenter.getWorkoutPlans(user!),
                    _getUsersPlaylistNames(user!),
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Playlist created successfully!"),
                        duration: Duration(seconds: 5),
                      ),
                    )
                  },
                ),
              ],
            );
          }),
        ));
  }

  AlertDialog savePlaylist(int index) {
    return AlertDialog(
      title: Text("Select Playlist to Save to"),
      content: SizedBox(
        height: 150,
        child: StatefulBuilder(builder: (context, StateSetter setState) {
          return Column(
            children: [
              DropdownButtonFormField<String>(
                hint: Text("Select Playlist"),
                isExpanded: true,
                value: selectedPlaylist,
                onChanged: (String? newValue) {
                  _getUsersPlaylistNames(user!);

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
              if (selectedPlaylist != null)
                Text("Selected Playlist:    " + selectedPlaylist!),
              if (selectedPlaylist == null) Text("No Playlist Selected"),
              ElevatedButton(
                  child: Text("Save"),
                  onPressed: () => {
                    selectedPlaylist!.isNotEmpty
                        ? saveWorkoutButton(user, selectedPlaylist, index)
                        : Text("No Playlist Selected"),
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Workout added successfully!"),
                        duration: Duration(seconds: 5),
                      ),
                    )
                  })
            ],
          );
        }),
      ),
    );
  }
  AlertDialog playlistSelectionScreen(){
    return AlertDialog(
        title: Text("Select Playlist to View"),
        content: SizedBox(
            height: 80,
            child: StatefulBuilder(builder: (context, StateSetter setState) {
              return Column(
                  children: [
                    DropdownButtonFormField<String>(
                      hint: Text("Select Playlist"),
                        isExpanded: true,
                        value: selectedPlaylist,
                        onChanged: (String? newValue) {
                          _getUsersPlaylistNames(user!);
                          _getSelectedWorkoutData(selectedPlaylist, user);
                          setState(() {
                            selectedPlaylist = newValue;
                          });
                        },
                        items: playlistNames
                          .map<DropdownMenuItem<String>>((dynamic playlist) {return DropdownMenuItem<String>(
                            value: playlist,
                            child: Text(playlist),
                          );
                          }).toList(),
                    ),
              if (selectedPlaylist != null)
                Text("Selected Playlist:    " + selectedPlaylist!),
              if (selectedPlaylist == null) Text("No Playlist Selected")
            ]
              );
            }
            )
        )
    );
  }

  // Show the instructions for a selected workout in a bottom sheet
  void viewInstructionContainer(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        //print(displayedWorkouts[index]);
        return SizedBox(
            height: (displayedWorkouts[index]["instructions"].length / 2.3),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Instructions"),
                  Text(displayedWorkouts[index]["instructions"],
                      style: TextStyle(letterSpacing: 0.8))
                ],
              ),
            ));
      },
      isScrollControlled: true,
    );
  }

  // Create a new workout playlist for the user
  void createPlaylistButton() {
    presenter.setWorkoutPlanName(
      user!,
      playlistName!,
    );
    return;
  }

  void saveWorkoutButton(String? user, String? planName, int selectedWorkoutIndex) {
    presenter.setWorkoutDetails(
        user!, planName!, displayedWorkouts, selectedWorkoutIndex);
  }


}
