class AlarmModel {
  String? alarmTime; // Stores alarm time in "HH:mm" format
  String selectedRingtone = 'samsung_ringtone.mp3'; // Default ringtone
  bool hasTriggered = false; // Flag to check if the alarm has triggered

  // Sets the alarm with a specific hour, minute, and ringtone
  void setAlarm(String hour, String minute, String ringtone) {
    alarmTime = '${hour.padLeft(2, '0')}:${minute.padLeft(2, '0')}'; // Format time to "HH:mm"
    selectedRingtone = ringtone;
    hasTriggered = false; // Reset triggered status
  }

  // Checks if the current time matches the alarm time and triggers the alarm
  bool isAlarmTime(DateTime currentTime) {
    if (alarmTime == null || hasTriggered) return false; // No alarm or already triggered

    final currentFormattedTime =
        '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}'; // Format current time

    if (currentFormattedTime == alarmTime) {
      hasTriggered = true; // Set alarm as triggered
      return true; // Time to trigger the alarm
    }

    return false; // Not the right time yet
  }

  // Returns the selected ringtone
  String getRingtone() => selectedRingtone;

  // Resets the alarm trigger status
  void resetAlarm() {
    hasTriggered = false;
  }
}
