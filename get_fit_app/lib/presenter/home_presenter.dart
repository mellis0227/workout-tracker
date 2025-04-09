import 'package:flutter/material.dart';

class HomePresenter {
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  final List<String> pageTitles = [
    'Dashboard',
    'Fitness Alarm',
    'Lifting Log',
    'Running Log',
    'Activity Log',
    'Workout API',
  ];

  void onSelectPage(int index) {
    currentIndex.value = index;
  }

  void dispose() {
    currentIndex.dispose();
  }
}
