import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_fit_app/viewmodel/api_model.dart';
import 'package:get_fit_app/views/workout_api_view.dart';
import 'package:go_router/go_router.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => WorkoutAPIScreen(),
    )
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

