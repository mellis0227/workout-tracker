import 'package:flutter/material.dart';
import '../presenter/home_presenter.dart';
import 'activity_log.dart';
import 'fitness_alarm_view.dart';
import 'lifting_log_view.dart';
import 'music_player_view.dart';
import 'running_log_view.dart';
import 'workout_api_view.dart';
import 'dashboard_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomePresenter _presenter; // Presenter that manages state
  late List<Widget> _pages; // List of pages/screens to display

  // Called when a tab is selected from the drawer or tabs
  void _onSelectTab(int index) {
    setState(() {
      _presenter.onSelectPage(index); // Update the page index in presenter
    });
  }

  @override
  void initState() {
    super.initState();
    _presenter = HomePresenter(); // Initialize presenter
    _pages = [
      DashboardView(onTabSelected: _onSelectTab), // Dashboard screen
      const AlarmApp(),
      const RunningLogView(),
      const LiftingLogView(),// Fitness alarm screen
      const ActivityLog(), // Activity log screen
      const WorkoutAPIScreen(), // Workout API screen
      const MusicPlayerView(), // Music player screen
    ];
  }

  @override
  void dispose() {
    _presenter.dispose(); // Clean up resources used by the presenter
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _presenter.currentIndex, // Listen to changes in selected page
      builder: (context, index, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_presenter.pageTitles[index]),
            elevation: 0,
            backgroundColor: const Color(0xFF01161E), // Rich black
            foregroundColor: const Color(0xFFEFF6E0), // Beige text
          ),
          drawer: Drawer(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Drawer header with a gradient background
                DrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF124559), Color(0xFF598392)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Text(
                    'Navigation', // Header text
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // List tiles for each tab
                ListTile(
                  leading: const Icon(Icons.line_axis),
                  title: const Text('Dashboard'),
                  onTap: () {
                    _presenter.onSelectPage(0); // Switch to Dashboard
                    Navigator.pop(context); // Close drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.alarm),
                  title: const Text('Fitness Alarm'),
                  onTap: () {
                    _presenter.onSelectPage(1); // Switch to Fitness Alarm
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.directions_run),
                  title: const Text('Running Log'),
                  onTap: () {
                    _presenter.onSelectPage(2); // Switch to Activity Log
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.fitness_center),
                  title: const Text('Lifting Log'),
                  onTap: () {
                    _presenter.onSelectPage(3); // Switch to Activity Log
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.timeline),
                  title: const Text('Activity Log'),
                  onTap: () {
                    _presenter.onSelectPage(4); // Switch to Activity Log
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.api),
                  title: const Text('Workouts'),
                  onTap: () {
                    _presenter.onSelectPage(5); // Switch to Workout API
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.music_note_rounded),
                  title: const Text('Music'),
                  onTap: () {
                    _presenter.onSelectPage(6); // Switch to Music
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          // Animated transition between pages
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _pages[index], // Display the selected page
          ),
        );
      },
    );
  }
}
