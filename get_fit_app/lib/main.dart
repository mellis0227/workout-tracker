import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_fit_app/views/authentication_screen_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Make sure the app is initialized before Firebase
  try {
    await Firebase.initializeApp(); // Initialize Firebase
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const AuthenticationScreen(),
    );
  }
}

/*
^^^ this is what ensures that the Login/Authentication screen
is what is shows up every time the app is opened.
More logic will probably need to be added somewhere to get it to
switch screens later.
 */