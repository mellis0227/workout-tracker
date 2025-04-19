import 'dart:async';
import 'package:flutter/material.dart';
import '../viewmodel/running_log_model.dart';
import '../presenter/running_log_presenter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RunningLogView extends StatefulWidget {
  const RunningLogView({super.key});

  @override
  _RunningLogViewState createState() => _RunningLogViewState();
}

class _RunningLogViewState extends State<RunningLogView> {
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final RunningLogPresenter _presenter = RunningLogPresenter();

  String _vanishingMessage = '';
  Timer? _vanishingTimer;
  String _selectedExercise = 'Run';
  String? _userID;

  @override
  void initState() {
    super.initState();
    _userID = FirebaseAuth.instance.currentUser?.email;
    print("Current user ID: $_userID");
  }

  void _logRun() {
    if (_userID == null) {
      _showVanishingMessage('User not logged in.');
      return;
    }

    if (_selectedExercise.isEmpty ||
        _distanceController.text.isEmpty ||
        _timeController.text.isEmpty) {
      _showVanishingMessage('Please fill in all fields.');
      return;
    }

    Run run = Run(
      run: _selectedExercise,
      distance: int.tryParse(_distanceController.text) ?? 0,
      time: int.tryParse(_timeController.text) ?? 0,
      userID: _userID ?? "",
    );

    _presenter.logRun(_userID!, run);
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
    _distanceController.dispose();
    _timeController.dispose();
    _vanishingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6E0), // Beige
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFAEC3B0), // Ash gray
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedExercise,
                    decoration: const InputDecoration(
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
                  const SizedBox(height: 20),
                  TextField(
                    controller: _distanceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Distance (miles)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _timeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Time (minutes)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _logRun,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF124559), // Midnight green
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Log Exercise'),
                  ),
                ],
              ),
            ),
            if (_vanishingMessage.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                _vanishingMessage,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF124559),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
