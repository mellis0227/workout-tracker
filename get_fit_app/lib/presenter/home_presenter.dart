import 'package:flutter/material.dart';

class HomePresenter {
  // A ValueNotifier to track the currently selected page index
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  // List of page titles corresponding to the index values
  final List<String> pageTitles = [
    'Dashboard',
    'Fitness Alarm',
    'Lifting Log',
    'Running Log',
    'Activity Log',
    'Workout API',
  ];

  // Updates the selected page index
  void onSelectPage(int index) {
    currentIndex.value = index;
  }

  // Disposes of the currentIndex ValueNotifier when no longer needed
  void dispose() {
    currentIndex.dispose();
  }
}
