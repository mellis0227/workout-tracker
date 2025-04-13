import '../viewmodel/running_log_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RunningLogPresenter {
  // Instance of FirebaseFirestore for interacting with Firestore database
  final FirebaseFirestore _firestoreRun = FirebaseFirestore.instance;

  // Logs a run to the Firestore database
  Future<void> logRun(Run run) async {
    // Adds the run data to the 'runs' collection in Firestore
    await _firestoreRun.collection('runs').add(run.toMap());
  }
}

