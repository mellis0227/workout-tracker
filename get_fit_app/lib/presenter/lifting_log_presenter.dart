import '../viewmodel/lifting_log_model.dart';

class LiftingLogPresenter {
  final LiftingLogModel model = LiftingLogModel();

  Future<void> logExercise(String userID, Exercise exercises) async {
    await model.logExercise(
      userID: userID,
      exercise: exercises.exercise,
      weight: exercises.weight,
      sets: exercises.sets,
      reps: exercises.reps);
  }
}
