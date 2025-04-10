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
  late final HomePresenter _presenter;
  late List<Widget> _pages;

  void _onSelectTab(int index) {
    setState(() {
      _presenter.onSelectPage(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _presenter = HomePresenter();
    _pages = [
      DashboardView(onTabSelected: _onSelectTab),
      const AlarmApp(),
      const RunningLogView(),
      const ActivityLog(),
      const WorkoutAPIScreen(),
      const MusicPlayerView(),
      const LiftingLogView(),
    ];
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _presenter.currentIndex,
      builder: (context, index, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_presenter.pageTitles[index]),
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
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
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Text(
                    'Navigation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.line_axis),
                  title: const Text('Dashboard'),
                  onTap: () {
                    _presenter.onSelectPage(0);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.alarm),
                  title: const Text('Fitness Alarm'),
                  onTap: () {
                    _presenter.onSelectPage(1);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.directions_run),
                  title: const Text('Running Log'),
                  onTap: () {
                    _presenter.onSelectPage(2);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.timeline),
                  title: const Text('Activity Log'),
                  onTap: () {
                    _presenter.onSelectPage(3);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.api),
                  title: const Text('Workout API'),
                  onTap: () {
                    _presenter.onSelectPage(4);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.music_note_rounded),
                  title: const Text('Music'),
                  onTap: () {
                    _presenter.onSelectPage(5);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.fitness_center),
                  title: const Text('Lifting Log'),
                  onTap: () {
                    _presenter.onSelectPage(6);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _pages[index],
          ),
        );
      },
    );
  }
}
