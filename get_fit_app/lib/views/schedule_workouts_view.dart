import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_fit_app/presenter/schedule_workout_presenter.dart';
/*
  notes:
   added onto dashboard instead of seperate page,
   a map needs to be populated and find a way to add multiple days into firebase probably best solution is a seperate collection
   person should be able to add multiple workouts
 */
class ScheduleWorkoutView extends StatefulWidget {
 const ScheduleWorkoutView({super.key});


 @override
 _ScheduleWorkoutView createState() => _ScheduleWorkoutView();
}


class _ScheduleWorkoutView extends State<ScheduleWorkoutView> {
  final ScheduleWorkoutPresenter _presenter = ScheduleWorkoutPresenter();
  DateTime currentDate = DateTime.now();
  String? currentAddedPlaylist;

  //stupid, dont do this
  Map<int, String> weeklyWorkouts = {
    1: "",
    2: "",
    3: "",
    4: "",
    5: "",
    6: "",
    7: "",
  };


  String? userID;
  List<String> playlists = [];

  void getPlaylists(String userID) async {
    List<dynamic> tempPlaylists = await _presenter.getPlaylists(userID);
    setState(() {
      playlists = tempPlaylists.map((item) => item.toString()).toList();
    });
  }

 @override
 void initState() {
    super.initState();
    userID = FirebaseAuth.instance.currentUser?.email;
    getPlaylists(userID!);
 }


 @override
 Widget build(BuildContext context) {
   return Scaffold(
       body: Column(
       children: [
         SingleChildScrollView(
           scrollDirection: Axis.horizontal,
           child: Row(
             children: [
               //make less D.R.Y lol
               _buildWeekDayCard(dayOfWeek: "Monday", index: 1),
               _buildWeekDayCard(dayOfWeek: "Tuesday", index: 2),
               _buildWeekDayCard(dayOfWeek: "Wednesday",  index: 3),
               _buildWeekDayCard(dayOfWeek: "Thursday",  index: 4),
               _buildWeekDayCard(dayOfWeek: "Friday",  index: 5),
               _buildWeekDayCard(dayOfWeek: "Saturday",  index: 6),
               _buildWeekDayCard(dayOfWeek: "Sunday",  index: 7),
             ],
           ),
         ),
       ],
     ),
   );
 }

  Widget _buildWeekDayCard({required String dayOfWeek, required int index}) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => buildPlaylistAlert(dayOfWeek, index),
          );
        },
        child: Container(
          width: 160,
          height: 80,
          decoration: BoxDecoration(
            color: Color(0xFF598392),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    dayOfWeek,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    weeklyWorkouts[index]!,
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFFAEC3B0),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }


 AlertDialog buildPlaylistAlert(String dayOfWeek, int index) {
    String formattedTime = dayOfWeek;
    return AlertDialog(
      title: Text("Select Your Playlist"),
      content: SizedBox(
        height: 50,
        child: Column(
          children: [
            DropdownButton<String>(
              hint: Text("Playlists", style: TextStyle(color: Colors.black)),
              isExpanded: true,
              items: playlists.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) => {
                _presenter.setWeekdayInFirebase(userID!, value!, dayOfWeek),
                setState(() {
                  weeklyWorkouts[index] = value;
                }),

                Navigator.pop(context),
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Added $value to $formattedTime"), duration: Duration(seconds: 2)),
                )
              },
            ),
          ],
        ),
      ),
    );
  }
}



