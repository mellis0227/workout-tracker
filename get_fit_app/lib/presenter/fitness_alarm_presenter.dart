
import 'dart:async';
import '../viewmodel/fitness_alarm_model.dart';

abstract class AlarmViewContract {
  void updateCurrentTime(String time);
  void showAlarmSet(String alarmTime);
  void showInputError(String message);
  void showAlarmTriggered();
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
    final formattedTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    _view.updateCurrentTime(formattedTime);

    if (_model.isAlarmTime(now)) {
      _view.showAlarmTriggered();
    }
  }

  void setAlarm(String hour, String minute) {
    if (hour.isEmpty || minute.isEmpty) {
      _view.showInputError('Please enter both hour and minute');
      return;
    }

    _model.setAlarm(hour, minute);
    _view.showAlarmSet(_model.alarmTime!);
  }
}