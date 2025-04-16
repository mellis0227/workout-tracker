import '../viewmodel/running_log_model.dart';

class RunningLogPresenter {
  final RunningLogModel _model = RunningLogModel();

  Future<void> logRun(String userID, Run run) async {
    await _model.logRun(
      userID: userID,
      run: run.run,
      distance: run.distance,
      time: run.time,
    );
  }
}
