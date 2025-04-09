import 'package:flutter/material.dart';
import 'package:get_fit_app/views/activity_log.dart';
import '../presenter/home_presenter.dart';
import 'fitness_alarm_view.dart';
import 'lifting_log_view.dart';
import 'running_log_view.dart';
import 'workout_api_view.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomePresenter _presenter;

  final List<Widget> _pages = const [
    AlarmApp(),
    LiftingLogView(),
    RunningLogView(),
    ActivityLog(),
    WorkoutAPIScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _presenter = HomePresenter();
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
            centerTitle: true,
            title: Text(_presenter.pageTitles[index],
              style: GoogleFonts.bebasNeue(
                fontSize: 35,
              ),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/luke-chesser-PHtp0cDBJSM-unsplash.jpg'),
                fit: BoxFit.cover)),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
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
                  leading: const Icon(Icons.alarm),
                  title: const Text('Fitness Alarm'),
                  onTap: () {
                    _presenter.onSelectPage(0);
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
                  leading: const Icon(Icons.fitness_center),
                  title: const Text('Lifting Log'),
                  onTap: () {
                    _presenter.onSelectPage(1);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.timeline),
                  title: const Text('Activity Log'),
                  onTap: () {
                    _presenter.onSelectPage(2);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.api),
                  title: const Text('Workout API'),
                  onTap: () {
                    _presenter.onSelectPage(3);
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