import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/presenter/fitness_presenter.dart';
import '/views/fitness_view.dart';

class FitnessViewModel extends ChangeNotifier {
  List<Workout> _workouts = [];
  WorkoutDetails? _workoutDetails;

  List<Workout> get workouts => _workouts;
  WorkoutDetails? get workoutDetails => _workoutDetails;

  void setWorkouts(List<Workout> newWorkouts) {
    _workouts = newWorkouts;
    notifyListeners();
  }

  void setWorkoutDetails(WorkoutDetails details) {
    _workoutDetails = details;
    notifyListeners();
  }
}