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
  bool viewWorkouts;
  ScheduleWorkoutView({super.key, required this.viewWorkouts});


 @override
 _ScheduleWorkoutView createState() => _ScheduleWorkoutView();
}


class _ScheduleWorkoutView extends State<ScheduleWorkoutView> {
  final ScheduleWorkoutPresenter _presenter = ScheduleWorkoutPresenter();
  DateTime currentDate = DateTime.now();
  String? currentAddedPlaylist;
  
  Map<String, List<dynamic>> weeklyWorkouts = {};


  String? userID;
  List<String> playlists = [];


  void getPlaylistsAndSetMap(String userID) async {
    List<dynamic> tempPlaylists = await _presenter.getPlaylists(userID);
    Map<String, List<dynamic>> tempMap = await _presenter.populateScheduleMap(userID);
    setState(() {
      playlists = tempPlaylists.map((item) => item.toString()).toList();
      weeklyWorkouts = tempMap;
    });
  }



 @override
 void initState() {
    super.initState();
    userID = FirebaseAuth.instance.currentUser?.email;
    getPlaylistsAndSetMap(userID!);
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
               _buildWeekDayCard(dayOfWeek: "Monday"),
               _buildWeekDayCard(dayOfWeek: "Tuesday"),
               _buildWeekDayCard(dayOfWeek: "Wednesday"),
               _buildWeekDayCard(dayOfWeek: "Thursday"),
               _buildWeekDayCard(dayOfWeek: "Friday"),
               _buildWeekDayCard(dayOfWeek: "Saturday"),
               _buildWeekDayCard(dayOfWeek: "Sunday"),
             ],
           ),
         ),
       ],
     ),
   );
 }

  Widget _buildWeekDayCard({required String dayOfWeek}) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => buildPlaylistAlert(dayOfWeek),
          );
        },
        child: Container(
          width: 160,
          height: !widget.viewWorkouts ? 65 : 200,
          decoration: BoxDecoration(
            color: Color(0xFF598392),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    dayOfWeek,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.8,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      );
  }

  Container buildSinglePlaylist(String playListName) {
    return Container(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Text(
                playListName,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFAEC3B00),
                ),
              ),
              Icon(
                Icons.delete,
                color: Color(0xFF01161E),
              ),
            ],
          ),
        ),
    );
  }


 AlertDialog buildPlaylistAlert(String dayOfWeek) {
    String formattedTime = dayOfWeek;
    return AlertDialog(
      backgroundColor: Color(0xFF01161E),
      title: Text("Select Your Workouts", style: TextStyle(color: Colors.white70),),
      content: SizedBox(
        height: 50,
        child: Column(
          children: [
            DropdownButton<String>(
              dropdownColor: Color(0xFF01161E),
              hint: Text("Playlists", style: TextStyle(color: Colors.white70)),
              isExpanded: true,
              items: playlists.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: Colors.white70),),
                );
              }).toList(),
              onChanged: (value) => {
                _presenter.setWeekdayInFirebase(userID!, value!, dayOfWeek),
                if(!weeklyWorkouts[dayOfWeek]!.contains(value)){
                  setState(() {
                    weeklyWorkouts[dayOfWeek]?.add(value);
                  }),
                },
               // print(_presenter.formatScheduleSubtext(weeklyWorkouts[dayOfWeek]!)),

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



