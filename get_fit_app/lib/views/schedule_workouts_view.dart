import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_fit_app/presenter/schedule_workout_presenter.dart';
import 'package:table_calendar/table_calendar.dart';
/*
  notes:
    maybe it would make more sense to have just the weekdays in a
    nice formatted schedule look instead of using a calendar
    why have a non consistent workout schedule lol
     -- get datetime.weekday in dashboard, then work from there
     -- scheduled list firebase ex:
          "Leg Day": {workout information and stuff}, "scheduled_day": "Monday"
    this would be more intuitive and make more sense with consistency and such
 */
class ScheduleWorkoutView extends StatefulWidget {
 const ScheduleWorkoutView({super.key});


 @override
 _ScheduleWorkoutView createState() => _ScheduleWorkoutView();
}


class _ScheduleWorkoutView extends State<ScheduleWorkoutView> {
  final ScheduleWorkoutPresenter _presenter = ScheduleWorkoutPresenter();
  Map<int, String> weekDayNames = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday"
  };

  String? userID;
  List<String> playlists = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
         TableCalendar(
             firstDay: DateTime.utc(2025, 4, 16),
             lastDay: DateTime.utc(2050, 4, 16),
             focusedDay: DateTime.now(),
             calendarFormat: CalendarFormat.month,
             onDaySelected: (focusedDay, selectedDay) {
               setState(() {
                 _focusedDay = focusedDay;
                 _selectedDay = selectedDay;
               });
               showDialog(
                 context: context,
                 builder: (BuildContext context) => buildPlaylistAlert(selectedDay),
               );
             }
         ),
       ],
     ),
   );
 }

  AlertDialog buildPlaylistAlert(DateTime currentDate) {
    String formattedTime = "${weekDayNames[currentDate.weekday]} the ${currentDate.day}";
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
                _presenter.setWeekdayInFirebase(userID!, value!, currentDate),
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



