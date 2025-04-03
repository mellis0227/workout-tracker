import 'package:cloud_firestore/cloud_firestore.dart';

class Run {
  String id;
  String run;
  int distance;
  int time;
  

  Run({
    required this.id,
    required this.run,
    required this.distance,
    required this.time,});

  Map<String, dynamic> toMap(){
    return {
      'run': run,
      'distance': distance,
      'time': time,
    };
  }
  }

class RunningLogModel {
final FirebaseFirestore firestoreRun = FirebaseFirestore.instance;
RunningLogModel();
List<Run> runs = [];

Future<void> logrun(String run, int distance, int time,
    ) async {
  try {
    await firestoreRun.collection('runs').add({
      '_run': run,
      '_distance': distance,
      '_time': time,
    });
  } catch (e) {
    print('Error logging run');
  }
}
}