import 'package:get_fit_app/viewmodel/do_workout_model.dart';

class DoWorkoutPresenter {
  DoWorkoutModel model = DoWorkoutModel();


  Future<List<Workouts>> getPlaylistData(String playlist, String userID ) async {
    return await model.getPlaylistData(playlist, userID);
  }
}