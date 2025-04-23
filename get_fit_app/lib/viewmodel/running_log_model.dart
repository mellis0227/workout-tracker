import 'package:cloud_firestore/cloud_firestore.dart';

class Run {
  String userID;
  String run;
  int? distance;
  int time;

  Run({
    required this.userID,
    required this.run,
    this.distance,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'run': run,
      'distance': distance,
      'time': time,
    };
  }
}

class RunningLogModel {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> logRun({
    required String userID,
    required String run,
    int? distance,
    required int time,
  }) async {
    final data = {
      'run': run,
      'time': time,
    };

    if (distance != null) {
      data['distance'] = distance;
    }
    try {
      await firestore
          .collection('user_data')
          .doc(userID)
          .collection('runs')
          .add(data);
    } catch (e) {
      print('Error logging run: $e');
    }
  }
}