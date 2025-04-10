import 'package:cloud_firestore/cloud_firestore.dart';

// Run class to represent individual run data
class Run {
  String id;
  String run;
  int distance;
  int time;

  // Constructor to initialize run details
  Run({
    required this.id,
    required this.run,
    required this.distance,
    required this.time,
  });

  // Converts the run object to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'run': run,
      'distance': distance,
      'time': time,
    };
  }
}

class RunningLogModel {
  final FirebaseFirestore firestoreRun = FirebaseFirestore.instance; // Instance of Firestore
  RunningLogModel();

  // List to store run records
  List<Run> runs = [];

  // Logs a new run into Firestore
  Future<void> logrun(
      String run,
      int distance,
      int time,
      ) async {
    try {
      // Adding run data to Firestore under the 'runs' collection
      await firestoreRun.collection('runs').add({
        '_run': run,
        '_distance': distance,
        '_time': time,
      });
    } catch (e) {
      print('Error logging run'); // Catching and logging any errors
    }
  }
}

