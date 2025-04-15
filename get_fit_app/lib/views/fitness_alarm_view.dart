import 'package:flutter/material.dart';
import '../presenter/fitness_alarm_presenter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class AlarmApp extends StatelessWidget {
  const AlarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF6F7FB),
        primaryColor: Color(0xFF007AFF), // Primary blue color
        colorScheme: ColorScheme.light(
          primary: Color(0xFF007AFF),
          secondary: Color(0xFF34C759), // Green for success messages
          error: Color(0xFFFF3B30), // Red for error messages
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF1C1C1E)), // Dark text for body
          bodySmall: TextStyle(color: Color(0xFF6E6E73)), // Light text for sub-headings
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(color: Color(0xFF1C1C1E)),
          titleTextStyle: TextStyle(
            color: Color(0xFF1C1C1E),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF007AFF),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 6,
          ),
        ),
      ),
      home: AlarmView(), // Home screen is AlarmView
    );
  }
}

class AlarmView extends StatefulWidget {
  const AlarmView({super.key});

  @override
  _AlarmViewState createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> implements AlarmViewContract {
  late AlarmPresenter _presenter; // Presenter for alarm logic
  String _currentTime = ''; // Stores the current time
  String? _alarmTime; // Stores the alarm time once set

  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();

  final List<String> _ringtones = [
    'samsung_ringtone.mp3', '1985_ring.mp3', 'army_wake_up.mp3',
    'air_raid_siren.mp3', 'extreme_alarm_clock.mp3',
  ]; // Available ringtones
  String _selectedRingtone = 'samsung_ringtone.mp3'; // Default ringtone

  @override
  void initState() {
    super.initState();
    _presenter = AlarmPresenter(this); // Initialize presenter
    _presenter.startClock(); // Start clock to update current time
  }

  @override
  void dispose() {
    _presenter.dispose(); // Clean up presenter
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  void updateCurrentTime(String time) {
    setState(() {
      _currentTime = time; // Update current time in UI
    });
  }

  @override
  void showAlarmSet(String alarmTime) {
    setState(() {
      _alarmTime = alarmTime; // Update alarm time when set
    });

    // Show a confirmation snack bar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alarm set for $alarmTime')),
    );
  }

  @override
  void showInputError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)), // Show error message
    );
  }

  @override
  void showAlarmTriggered(String ringtonePath) async {
    final player = AudioPlayer();
    await player.play(AssetSource('ringtones/$ringtonePath')); // Play selected ringtone

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alarm is ringing!')),
    );
  }

  void _onSetAlarmPressed() {
    final hourText = _hourController.text;
    final minuteText = _minuteController.text;

    final hour = int.tryParse(hourText);
    final minute = int.tryParse(minuteText);

    // Validate time input
    if (hour == null || minute == null || hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      showInputError('Please enter a valid hour (0–23) and minute (0–59)');
      return;
    }

    _presenter.setAlarm(hourText, minuteText, _selectedRingtone); // Set the alarm
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text(
                'Current Time:',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                _currentTime,
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text('Pick Alarm Time:', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 12),
                    TimePickerSpinner(
                      is24HourMode: true,
                      normalTextStyle:
                      TextStyle(fontSize: 18, color: Colors.black54),
                      highlightedTextStyle: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.primary),
                      spacing: 40,
                      itemHeight: 50,
                      isForce2Digits: true,
                      onTimeChange: (time) {
                        _hourController.text = time.hour.toString();
                        _minuteController.text = time.minute.toString();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Ringtone:', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    DropdownButton<String>(
                      value: _selectedRingtone,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRingtone = newValue!; // Update selected ringtone
                        });
                      },
                      items: _ringtones.map((ringtone) {
                        return DropdownMenuItem(
                          value: ringtone,
                          child: Text(ringtone), // Display ringtone names
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _onSetAlarmPressed,
                child: Text('Set Alarm', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 20),
              if (_alarmTime != null)
                Text(
                  'Alarm Set For: $_alarmTime', // Display alarm time
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
