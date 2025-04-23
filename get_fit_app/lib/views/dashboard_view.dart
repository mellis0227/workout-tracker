import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_fit_app/presenter/schedule_workout_presenter.dart';
import 'package:get_fit_app/views/schedule_workouts_view.dart';
import '../presenter/dashboard_presenter.dart';
import '../viewmodel/dashboard_model.dart';
import 'do_workouts_view.dart';

class DashboardView extends StatefulWidget {
  final void Function(int index)? onTabSelected; // Callback for tab selection

  // Constructor initializes the presenter with a model
  const DashboardView({super.key, this.onTabSelected});

  @override
  _DashboardViewState createState() {
    return _DashboardViewState();
  }
}

class _DashboardViewState extends State<DashboardView> {
  late final DashboardPresenter _presenter;
  late final ScheduleWorkoutPresenter _schedulePresenter;
  late String welcomeMessage; // Get welcome message
  late String quote; // Get motivational quote// Presenter to handle logic
  //the userID is capable of fetching data && full name is the users displayed name
  String? userID;
  String fullName = "";
  DateTime currentDate = DateTime.now();
  String currentDateString = "";
  bool viewWorkoutPlan = false;
  List<dynamic> currentPlaylist = [];
  String? currentWeekday;
  bool isScheduled = false;

  Future<void> getFullName(String userID) async {
    String tempFullName = await _presenter.getUsersFullName(userID);
    setState(() {
      if (tempFullName.isNotEmpty) {
        fullName = tempFullName;
      }
    });
  }

  Future<void> getPlaylist(String weekDay) async {
    List<dynamic> tempList = await _schedulePresenter.getWeekDayPlaylist(userID!, weekDay);
    setState(() {
      currentPlaylist = tempList;
      isScheduled = currentPlaylist.isNotEmpty;
    });
  }



  @override
  void initState() {
    super.initState();
    _presenter = DashboardPresenter(model: DashboardModel());
    _schedulePresenter = ScheduleWorkoutPresenter();
    userID = FirebaseAuth.instance.currentUser?.email;
    getFullName(userID!);
    currentWeekday = _presenter.getWeekdayString(currentDate);
    getPlaylist(currentWeekday!);
    quote = _presenter.getMotivationalQuote(); // Get motivational quote// Presenter to handle logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Padding(
        //conditional padding for no schedule overflow, temporary solution
        padding: EdgeInsets.all(fullName.length > 12 ? 12 : 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the welcome message
            Center(
              child: buildWelcomeText(context),
            ),
           const SizedBox(height: 30),

            // Display workout summary card (No workout scheduled)
            _buildCard(
              title: "Today's Workout",
              content: currentPlaylist.isEmpty ? "No workout scheduled. Let's get moving!" : "Today is $currentWeekday. Let's get moving!",
              isScheduled: isScheduled,
            ),
            const SizedBox(height: 16),

            // Display motivational quote card
            _buildCard(
              title: "Motivation",
              content: '"$quote"',
              isItalic: true, // Quote is italicized
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  "Workout Schedule",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1C1C1E),
                  ),
                ),
                const SizedBox(width: 5),
                TextButton(
                    child: Text(
                      !viewWorkoutPlan ? "Press to View Workouts" : "Close Workouts",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => {
                      setState(() {
                        if(viewWorkoutPlan){
                          viewWorkoutPlan = false;
                        } else {
                          viewWorkoutPlan = true;
                        }
                      }),
                    }
                ),
              ],
            ),
            Expanded(
              child: ScheduleWorkoutView(
                viewWorkouts: viewWorkoutPlan,
                onPlaylistScheduled: ()  {
                   getPlaylist(currentWeekday!);
                }
              ),
            ),
            // Quick Access section header

            // Quick access tiles for different functionalities
            Text(
              "Quick Access",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1C1C1E),
                  letterSpacing: .8
              ),
            ),
            Padding(padding: EdgeInsets.all(4)),
            _buildTile(context, Icons.api, 'Find Workouts', 5),
            _buildTile(context, Icons.music_note_rounded, 'Music Player', 6),

            //conditional check so no overlapping widgets after view workout is pressed
            if(!viewWorkoutPlan) ... [
              _buildTile(context, Icons.alarm, 'Fitness Alarm', 1),
              _buildTile(context, Icons.timeline, 'Activity Log', 4),
            ]
          ],
        ),
      ),
    );
  }

  Text buildWelcomeText(BuildContext context) {
    if (fullName.length <= 12) {
      return Text(
        fullName.isNotEmpty ? "Welcome Back, $fullName!" : "Welcome Back!",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1C1C1E),
            letterSpacing: .5),
      );
    }
    return Text(
      fullName.isNotEmpty ? "Welcome Back\n$fullName!" : "Welcome Back!",
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: const Color(0xFF1C1C1E),
          letterSpacing: .5),
    );
  }

  // Helper method to build a card with title and content
  Widget _buildCard({
    required String title,
    required String content,
    bool isItalic = false,
    bool isScheduled = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF598392),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display card title
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          // Display card content, optionally italicized
          isScheduled ? Row(
            children: [
              Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFFAEC3B0),
                  fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                ),
              ),
             const SizedBox(width: 10),
             GestureDetector(
               onTap: () => {
               Navigator.of(context).push(
                 MaterialPageRoute(builder: (context) => DoWorkoutsView(playlists: currentPlaylist,)),
                ),
               },
               child: Icon(
                 Icons.start_rounded,
                 color: Colors.white,
                 size: 30,
               )
             ),
            ],
          ) :
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xFFAEC3B0),
              fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a clickable tile with an icon and title
  Widget _buildTile(
      BuildContext context, IconData icon, String title, int tabIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () =>
            widget.onTabSelected?.call(tabIndex), // Calls callback on tap
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF598392),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: Color(0xFFAEC3B0)), // Icon
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}