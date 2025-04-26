import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_fit_app/presenter/do_workouts_presenter.dart';
import 'package:get_fit_app/presenter/schedule_workout_presenter.dart';
import '../viewmodel/do_workout_model.dart';


class DoWorkoutsView extends StatefulWidget {
  final List<dynamic> playlists;

  const DoWorkoutsView({super.key, required this.playlists});

  @override
  _DoWorkoutsViewState createState() {
    return _DoWorkoutsViewState();
  }
}
/*
* note: there is something wrong with playlistNames and its connection to dashboard, i believe due to the constructor they as well adapt in the dasboard list*/

class _DoWorkoutsViewState extends State<DoWorkoutsView> {
  final DoWorkoutPresenter _doWorkoutPresenter = DoWorkoutPresenter();
  String? userID;
  bool onCheck = false;
  List<dynamic> playlistNames = [];
  Map<String, List<Workouts>> playlistInformation = {};

  void getPlaylistNames() {
    List<dynamic> copyPlay = widget.playlists;
    setState(() {
      playlistNames = copyPlay;
    });
  }

  void buildWorkoutInformation(String userID) async {
    Map<String, List<Workouts>> tempMap = {};
    if(!mounted) return;
    for(var playlist in playlistNames){
      List<Workouts> workout = await _doWorkoutPresenter.getPlaylistData(playlist, userID);
      tempMap[playlist] = workout;
    }
    setState(() {
      playlistInformation = tempMap;
    });
  }

  @override
  void initState() {
    super.initState();
    userID = FirebaseAuth.instance.currentUser?.email;
    getPlaylistNames();
    buildWorkoutInformation(userID!);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF6E0),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF01161E),
        foregroundColor: const Color(0xFFEFF6E0),
        title: Text("Workouts"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: playlistNames.isNotEmpty ? ListView.builder(
                itemCount: playlistNames.length,
                itemBuilder: (BuildContext context, int index) {
                  List<Workouts>? workouts = playlistInformation[playlistNames[index]];
                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: Card(
                        color: Color(0xFF598392),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: ExpansionTile(
                          iconColor: Color(0xFFEFF6E0),
                          textColor:  Color(0xFFEFF6E0),
                          collapsedIconColor: Color(0xFFEFF6E0),
                          collapsedTextColor: Color(0xFFEFF6E0),
                          title: Text(playlistNames[index]),
                          leading: IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              setState(() {
                                playlistNames.remove(playlistNames[index]);
                              });
                            },
                          ),
                          children: workouts != null ? workouts.map((workout) {
                            return ListTile(
                              textColor: Color(0xFFEFF6E0),
                              title: Text(workout.workoutName),
                              subtitle: Text(workout.difficulty),
                              trailing: TextButton(
                                child: Text("View Instructions", style: TextStyle(color: Color(0xFFEFF6E0)),),
                                onPressed: () => {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                            height: 500,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Text("Instructions"),
                                                  Text(workout.instructions,
                                                      style: TextStyle(letterSpacing: 0.8)
                                                  )
                                                ],
                                              ),
                                            )
                                        );
                                      }
                                  )
                                },
                              ),


                            );
                          }).toList() :
                          [Text("No Workouts Provided")],
                        )
                    ),
                  );
                },
              ) :
                Center(
                  child: Text(
                    "All Done!",
                    style: TextStyle(
                      color: Colors.black26,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                )
          );


  }
}