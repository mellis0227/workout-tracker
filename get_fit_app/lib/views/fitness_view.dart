import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/viewmodel/fitness_model.dart';
import '/presenter/fitness_presenter.dart';

class FitnessScreen extends StatelessWidget implements FitnessView {
  final FitnessPresenter presenter;

  FitnessScreen(this.presenter);

  @override
  Widget build(BuildContext context) {
    // This is the UI part
    return Scaffold(
      appBar: AppBar(title: Text("Get Fit")),
      body: Center(
        child: Text("Welcome to Get Fit App"),
      ),
    );
  }
  
  @override
  void displayWorkoutDetails(details) {
    // TODO: implement displayWorkoutDetails
  }
  
  @override
  void displayWorkouts(workouts) {
    // TODO: implement displayWorkouts
  }

  @override
 
}

class FitnessPresenter {
}

class FitnessView {
  void displayWorkouts(workouts) {}

  void displayWorkoutDetails(details) {}
}

class Workout {
}

class WorkoutDetails {
}