
class AlarmModel {
  String? alarmTime; // Stores in "HH:mm" format

  void setAlarm(String hour, String minute) {
    alarmTime = '${hour.padLeft(2, '0')}:${minute.padLeft(2, '0')}';
  }

  bool isAlarmTime(DateTime currentTime) {
    if (alarmTime == null) return false;
    final currentFormattedTime =
        '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}';
    return currentFormattedTime == alarmTime;
  }
}