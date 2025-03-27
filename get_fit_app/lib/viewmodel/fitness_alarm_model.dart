
class AlarmModel {
  String? alarmTime; // Stores in "HH:mm" format
  String selectedRingtone = 'samsung_ringtone.mp3';
  bool hasTriggered = false; 

  void setAlarm(String hour, String minute, String ringtone) {
    alarmTime = '${hour.padLeft(2, '0')}:${minute.padLeft(2, '0')}';
    selectedRingtone = ringtone;
    hasTriggered = false; 
  }

  bool isAlarmTime(DateTime currentTime) {
    if (alarmTime == null || hasTriggered) return false;

    final currentFormattedTime =
        '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}';

    if (currentFormattedTime == alarmTime) {
      hasTriggered = true;
      return true;
    }

    return false;
  }

  String getRingtone() => selectedRingtone;

  void resetAlarm() {
    hasTriggered = false;
  }
}