import 'dart:async';
import '../viewmodel/fitness_alarm_model.dart';

// Abstract contract that the view must implement to update the UI
abstract class AlarmViewContract {
  void updateCurrentTime(String time);
  void showAlarmSet(String alarmTime);
  void showInputError(String message);
  void showAlarmTriggered(String ringtone);
}

class AlarmPresenter {
  final AlarmViewContract _view; // View interface for UI updates
  final AlarmModel _model; // Model that handles alarm logic
  Timer? _timer; // Timer for periodic updates of current time

  // Constructor initializing the view and model
  AlarmPresenter(this._view) : _model = AlarmModel();

  // Starts the clock and updates time every second
  void startClock() {
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  // Cancels the timer when no longer needed
  void dispose() {
    _timer?.cancel();
  }

  // Updates the current time and checks if the alarm should be triggered
  void _updateTime() {
    final now = DateTime.now();

    final timeOnly =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    _view.updateCurrentTime(
        '$timeOnly:${now.second.toString().padLeft(2, '0')}'); // for UI only

    if (_model.isAlarmTime(now)) {
      print("Alarm triggered at $timeOnly");
      _view.showAlarmTriggered(_model.getRingtone());
    }
  }

  // Sets an alarm with the given hour, minute, and ringtone
  void setAlarm(String hour, String minute, String ringtone) {
    if (hour.isEmpty || minute.isEmpty) {
      _view.showInputError('Please enter both hour and minute');
      return;
    }

    _model.setAlarm(hour, minute, ringtone);
    _view.showAlarmSet(_model.alarmTime!);
  }
}
