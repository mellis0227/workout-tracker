import 'dart:async';
import 'package:flutter/material.dart';
import '../viewmodel/running_log_model.dart';
import '../presenter/running_log_presenter.dart';

class runningLogView extends StatelessWidget {
  const runningLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Run/Walk Log',
      home: runningLog(),
    );
  }
}

class runningLog extends StatefulWidget {
  const runningLog({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<runningLog> {
  final TextEditingController _runController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final RunningLogPresenter _presenter = RunningLogPresenter();

  String _vanishingMessage = '';
  Timer? _vanishingTimer;
  String _selectedExercise = 'Run';

  void _logRun() {
  if (_selectedExercise.isEmpty ||
      _distanceController.text.isEmpty ||
      _timeController.text.isEmpty) {
    return;
  }

  Run run = Run(
    run: _selectedExercise, // Use the selected value
    distance: int.tryParse(_distanceController.text) ?? 0,
    time: int.tryParse(_timeController.text) ?? 0,
    id: '',
  );

  _presenter.logRun(run);

  _distanceController.clear();
  _timeController.clear();
  _showVanishingMessage('Exercise logged successfully!');
}


  void _showVanishingMessage(String message) {
    setState(() {
      _vanishingMessage = message;
    });
    _startVanishingMessageTimer();
  }

  void _startVanishingMessageTimer() {
    _vanishingTimer?.cancel();
    _vanishingTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _vanishingMessage = '';
        });
      }
    });
  }

  @override
  void dispose() {
    _runController.dispose();
    _distanceController.dispose();
    _timeController.dispose();
    _vanishingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Run/Walk Log'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
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
                        _selectedExercise = newValue!;
                          });
                         },
                       ),
                  Text("Distance"),
                  TextField(
                    controller: _distanceController,
                    decoration: InputDecoration(
                      labelText: 'Enter distance here (miles)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Time"),
                  TextField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      labelText: 'Enter Time here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _logRun,
                    child: Text('Log Exercise'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
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
        ],
      ),
    );
  }
}