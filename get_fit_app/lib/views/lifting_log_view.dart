import 'dart:async';
import 'package:flutter/material.dart';
import '../viewmodel/lifting_log_model.dart';
import '../presenter/lifting_log_presenter.dart';

// This is the main widget that wraps the LiftingLog inside a MaterialApp
class LiftingLogView extends StatelessWidget {
  const LiftingLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lifting Log',
      home: LiftingLog(), // The LiftingLog widget is the home screen for this app
    );
  }
}

// StatefulWidget to handle the dynamic state of logging exercises
class LiftingLog extends StatefulWidget {
  const LiftingLog({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LiftingLog> {
  // Controllers to manage the state of each input field
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();

  final LiftingLogPresenter _presenter = LiftingLogPresenter(); // Presenter that handles the business logic

  String _vanishingMessage = ''; // Holds the message to show after logging
  Timer? _vanishingTimer; // Timer to remove the vanishing message after a few seconds

  // Function to log an exercise when the user presses the 'Log Exercise' button
  void _logExercise() {
    // Check if all fields are filled
    if (_exerciseController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _setsController.text.isEmpty ||
        _repsController.text.isEmpty) {
      return; // Do nothing if any of the fields are empty
    }

    // Create an Exercise object using the input values
    Exercise exercise = Exercise(
      exercise: _exerciseController.text,
      weight: int.tryParse(_weightController.text) ?? 0, // Default to 0 if parsing fails
      sets: int.tryParse(_setsController.text) ?? 0,
      reps: int.tryParse(_repsController.text) ?? 0,
      id: '', // The ID can be handled by the backend or database later
    );

    // Call the presenter to log the exercise
    _presenter.logExercise(exercise);

    // Clear the text fields after logging the exercise
    _exerciseController.clear();
    _weightController.clear();
    _setsController.clear();
    _repsController.clear();

    // Show a confirmation message to the user
    _showVanishingMessage('Exercise logged successfully!');
  }

  // Function to show the success message that disappears after a few seconds
  void _showVanishingMessage(String message) {
    setState(() {
      _vanishingMessage = message; // Set the success message
    });
    _startVanishingMessageTimer(); // Start the timer to hide the message
  }

  // Function to start the timer that clears the success message after 3 seconds
  void _startVanishingMessageTimer() {
    _vanishingTimer?.cancel(); // Cancel any previous timers
    _vanishingTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _vanishingMessage = ''; // Clear the message after 3 seconds
        });
      }
    });
  }

  // Dispose of controllers and timer to free up resources
  @override
  void dispose() {
    _exerciseController.dispose();
    _weightController.dispose();
    _repsController.dispose();
    _setsController.dispose();
    _vanishingTimer?.cancel(); // Cancel the timer if the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent layout issues when the keyboard is displayed
      appBar: AppBar(
        title: Text('Lifting Log'), // Title of the screen
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          // Main form to enter the exercise data
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Exercise Name Input
                  Text("Exercise"),
                  TextField(
                    controller: _exerciseController,
                    decoration: InputDecoration(
                      labelText: 'Enter exercise here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Weight Input
                  Text("Weight"),
                  TextField(
                    controller: _weightController,
                    decoration: InputDecoration(
                      labelText: 'Enter weight here (lbs)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Reps Input
                  Text("Reps"),
                  TextField(
                    controller: _repsController,
                    decoration: InputDecoration(
                      labelText: 'Enter reps here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Sets Input
                  Text("Sets"),
                  TextField(
                    controller: _setsController,
                    decoration: InputDecoration(
                      labelText: 'Enter sets here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Button to log the exercise
                  ElevatedButton(
                    onPressed: _logExercise, // Call _logExercise when pressed
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Set button color
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Log Exercise'),
                  ),
                  // Display the success message (if any)
                  Column(
                    children: [
                      if (_vanishingMessage.isNotEmpty)
                        Column(
                          children: [
                            SizedBox(height: 20),
                            Text(
                              _vanishingMessage,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
          // Row of icons for other sections (Home, Activity, Schedule, Profile)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Transform.scale(
                scale: 1.5,
                child: IconButton(
                  icon: Icon(Icons.home),
                  color: Colors.blue,
                  onPressed: () => print('Home pressed'),
                ),
              ),
              Transform.scale(
                scale: 1.5,
                child: IconButton(
                  icon: Icon(Icons.auto_graph),
                  color: Colors.blue,
                  onPressed: () => print('Activity pressed'),
                ),
              ),
              Transform.scale(
                scale: 1.5,
                child: IconButton(
                  icon: Icon(Icons.alarm),
                  color: Colors.blue,
                  onPressed: () => print('Schedule pressed'),
                ),
              ),
              Transform.scale(
                scale: 1.5,
                child: IconButton(
                  icon: Icon(Icons.person),
                  color: Colors.blue,
                  onPressed: () => print('Profile pressed'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
