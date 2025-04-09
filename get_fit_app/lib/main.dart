import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_fit_app/views/fitness_alarm_view.dart';
import 'package:get_fit_app/views/lifting_log_view.dart';
import 'package:get_fit_app/views/profile_view.dart';
import 'package:go_router/go_router.dart';
import 'package:get_fit_app/views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Make sure the app is initialized before Firebase
  try {
    await Firebase.initializeApp(); // Initialize Firebase
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(MyApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ProfileView(),
    ),

  ]
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

