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

class _DoWorkoutsViewState extends State<DoWorkoutsView> {
  final ScheduleWorkoutPresenter _schedulePresenter = ScheduleWorkoutPresenter();
  final DoWorkoutPresenter _doWorkoutPresenter = DoWorkoutPresenter();
  String? userID;
  List<dynamic> playlistNames = [];
  Map<String, List<Workouts>> playlistInformation = {};

  void getPlaylistNames() async {
    setState(() {
      playlistNames = widget.playlists;
    });
  }

  void buildWorkoutInformation(String userID) async {
    Map<String, List<Workouts>> tempMap = {};
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
    print(playlistInformation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: ListView.builder(
                itemCount: playlistNames.length,
                itemBuilder: (BuildContext context, int index) {
                  List<Workouts>? workouts = playlistInformation[playlistNames[index]];
                  return Card(
                    elevation: .5,
                    child: ExpansionTile(
                      title: Text(playlistNames[index]),
                      children: workouts != null
                            ? workouts.map((workout) => ListTile(
                          title: Text(workout.workoutName), // adjust to match your Workouts model
                        )).toList()
                            : [Text("Loading...")],
                    )
                  );
                },
              ),
          );


  }
}