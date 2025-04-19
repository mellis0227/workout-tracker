import 'dart:async';
import 'package:flutter/material.dart';
import '../viewmodel/lifting_log_model.dart';
import '../presenter/lifting_log_presenter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LiftingLogView extends StatefulWidget {
  const LiftingLogView({super.key});

  @override
  _LiftingLogViewState createState() => _LiftingLogViewState();
}

class _LiftingLogViewState extends State<LiftingLogView> {
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();

  final LiftingLogPresenter _presenter = LiftingLogPresenter();
  String? _userID;
  String _vanishingMessage = '';
  Timer? _vanishingTimer;

  @override
  void initState() {
    super.initState();
    _userID = FirebaseAuth.instance.currentUser?.email;
    print("Current user ID: $_userID");
  }

  void _logExercise() {
    if (_exerciseController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _setsController.text.isEmpty ||
        _repsController.text.isEmpty) {
      return _showVanishingMessage('Please provide input for all boxes.');
    }

    Exercise exercise = Exercise(
      exercise: _exerciseController.text,
      weight: int.tryParse(_weightController.text) ?? 0,
      sets: int.tryParse(_setsController.text) ?? 0,
      reps: int.tryParse(_repsController.text) ?? 0,
      userID: _userID ?? '',
    );

    _presenter.logExercise(_userID!, exercise);

    _exerciseController.clear();
    _weightController.clear();
    _setsController.clear();
    _repsController.clear();
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
    _exerciseController.dispose();
    _weightController.dispose();
    _repsController.dispose();
    _setsController.dispose();
    _vanishingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6E0), // Beige
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
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
                  TextField(
                    controller: _exerciseController,
                    decoration: const InputDecoration(
                      labelText: 'Exercise',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Weight (lbs)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Reps',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _setsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Sets',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _logExercise,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF124559), // Midnight green
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Log Exercise'),
                  ),
                  if (_vanishingMessage.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      _vanishingMessage,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF124559),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}