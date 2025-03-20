import 'package:flutter/material.dart';
import 'package:get_fit_app/loginScreenFramework/authentication_screen.dart';

void main() => runApp(const MyApp());

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