import 'dart:async';
import '../viewmodel/fitness_alarm_model.dart';

abstract class AlarmViewContract {
  void updateCurrentTime(String time);
  void showAlarmSet(String alarmTime);
  void showInputError(String message);
  void showAlarmTriggered(String ringtone);
}

class AlarmPresenter {
  final AlarmViewContract _view;
  final AlarmModel _model;
  Timer? _timer;

  AlarmPresenter(this._view) : _model = AlarmModel();

  void startClock() {
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void dispose() {
    _timer?.cancel();
  }

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

  void setAlarm(String hour, String minute, String ringtone) {
    if (hour.isEmpty || minute.isEmpty) {
      _view.showInputError('Please enter both hour and minute');
      return;
    }

    _model.setAlarm(hour, minute, ringtone);
    _view.showAlarmSet(_model.alarmTime!);
  }
}
