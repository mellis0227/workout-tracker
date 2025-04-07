import '../viewmodel/running_log_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RunningLogPresenter {
  final FirebaseFirestore _firestoreRun = FirebaseFirestore.instance;

  Future<void> logRun(Run run) async {
    await _firestoreRun.collection('runs').add(run.toMap());
  }
}
