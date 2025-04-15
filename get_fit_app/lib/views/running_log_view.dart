import 'dart:async';
import 'package:flutter/material.dart';
import '../viewmodel/running_log_model.dart';
import '../presenter/running_log_presenter.dart';

// Running Log view widget
class RunningLogView extends StatelessWidget {
  const RunningLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Run/Walk Log',
      home: runningLog(),
    );
  }
}

// Stateful widget for running log input
class runningLog extends StatefulWidget {
  const runningLog({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<runningLog> {
  final TextEditingController _runController = TextEditingController(); // Controller for run field
  final TextEditingController _distanceController = TextEditingController(); // Controller for distance
  final TextEditingController _timeController = TextEditingController(); // Controller for time
  final RunningLogPresenter _presenter = RunningLogPresenter(); // Presenter to handle the logic

  String _vanishingMessage = ''; // Message that disappears after a set time
  Timer? _vanishingTimer; // Timer to hide the message after a few seconds
  String _selectedExercise = 'Run'; // Default exercise is 'Run'

  // Function to log the run or walk
  void _logRun() {
    // Ensure that all fields are filled before logging
    if (_selectedExercise.isEmpty ||
        _distanceController.text.isEmpty ||
        _timeController.text.isEmpty) {
      return;
    }

    // Create a Run object to hold the logged exercise information
    Run run = Run(
      run: _selectedExercise, // Selected exercise (Run or Walk)
      distance: int.tryParse(_distanceController.text) ?? 0, // Parse distance
      time: int.tryParse(_timeController.text) ?? 0, // Parse time
      id: '', // Empty id initially
    );

    // Pass the Run object to the presenter for logging
    _presenter.logRun(run);

    // Clear the input fields after logging
    _distanceController.clear();
    _timeController.clear();

    // Show a success message for 3 seconds
    _showVanishingMessage('Exercise logged successfully!');
  }

  // Function to display a temporary message
  void _showVanishingMessage(String message) {
    setState(() {
      _vanishingMessage = message; // Set the message to be displayed
    });
    _startVanishingMessageTimer(); // Start the timer to remove the message
  }

  // Function to start the timer for the vanishing message
  void _startVanishingMessageTimer() {
    _vanishingTimer?.cancel(); // Cancel any existing timer
    _vanishingTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _vanishingMessage = ''; // Clear the message after the timer
        });
      }
    });
  }

  // Dispose of controllers and the vanishing timer when the widget is disposed
  @override
  void dispose() {
    _runController.dispose();
    _distanceController.dispose();
    _timeController.dispose();
    _vanishingTimer?.cancel();
    super.dispose();
  }

  // Build the widget UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents resizing when keyboard shows
      appBar: AppBar(
        title: Text('Run/Walk Log'),
        centerTitle: true, // Center the title in the AppBar
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Add padding to the body
              child: Column(
                children: [
                  // Dropdown to select between 'Run' or 'Walk'
                  DropdownButtonFormField<String>(
                    value: _selectedExercise,
                    decoration: InputDecoration(
                      labelText: 'Select exercise',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Run', 'Walk'].map((String exercise) {
                      return DropdownMenuItem<String>(
                        value: exercise,
                        child: Text(exercise),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedExercise = newValue!; // Update selected exercise
                      });
                    },
                  ),
                  // Distance input field
                  Text("Distance (miles)"),
                  TextField(
                    controller: _distanceController,
                    decoration: InputDecoration(
                      labelText: 'Enter distance here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Time input field
                  Text("Time (minutes)"),
                  TextField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      labelText: 'Enter Time here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Button to log the run/walk exercise
                  ElevatedButton(
                    onPressed: _logRun, // Call the logRun function
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      foregroundColor: Colors.white, // Text color
                    ),
                    child: Text('Log Exercise'),
                  ),
                  // Display the vanishing message
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
                                color: Colors.blue, // Message color
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
        ],
      ),
    );
  }
}
