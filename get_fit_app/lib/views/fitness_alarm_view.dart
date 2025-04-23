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
        scaffoldBackgroundColor: const Color(0xFFEFF6E0), // Beige
        primaryColor: const Color(0xFF124559), // Midnight green
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF124559), // Midnight green
          secondary: Color(0xFF598392), // Air Force blue
          background: Color(0xFFEFF6E0), // Beige
          surface: Color(0xFFAEC3B0), // Ash gray
          error: Color(0xFFFF3B30), // Red
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF01161E)), // Rich black
          bodySmall: TextStyle(color: Color(0xFF124559)), // Midnight green
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF01161E),
          elevation: 1,
          iconTheme: IconThemeData(color: Color(0xFFEFF6E0)),
          titleTextStyle: TextStyle(
            color: Color(0xFFEFF6E0),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF124559),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 6,
          ),
        ),
      ),
      home: const AlarmView(),
    );
  }
}

class AlarmView extends StatefulWidget {
  const AlarmView({super.key});

  @override
  _AlarmViewState createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> with AutomaticKeepAliveClientMixin implements AlarmViewContract {
  late AlarmPresenter _presenter;
  String _currentTime = '';
  String? _alarmTime;

  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();

  final List<String> _ringtones = [
    'samsung_ringtone.mp3',
    '1985_ring.mp3',
    'army_wake_up.mp3',
    'air_raid_siren.mp3',
    'extreme_alarm_clock.mp3',
  ];
  String _selectedRingtone = 'samsung_ringtone.mp3';

  @override
  void initState() {
    super.initState();
    _presenter = AlarmPresenter(this);
    _presenter.startClock();
  }

  @override
  void dispose() {
    _presenter.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  void updateCurrentTime(String time) {
    setState(() {
      _currentTime = time;
    });
  }

  @override
  void showAlarmSet(String alarmTime) {
    setState(() {
      _alarmTime = alarmTime;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alarm set for $alarmTime')),
    );
  }

  @override
  void showInputError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void showAlarmTriggered(String ringtonePath) async {
    final player = AudioPlayer();
    await player.play(AssetSource('ringtones/$ringtonePath'));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alarm is ringing!')),
    );
  }

  void _onSetAlarmPressed() {
    final hourText = _hourController.text;
    final minuteText = _minuteController.text;

    final hour = int.tryParse(hourText);
    final minute = int.tryParse(minuteText);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      showInputError('Please enter a valid hour (0–23) and minute (0–59)');
      return;
    }

    _presenter.setAlarm(hourText, minuteText, _selectedRingtone);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                'Current Time:',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                _currentTime,
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('Pick Alarm Time:',
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 12),
                    TimePickerSpinner(
                      is24HourMode: true,
                      normalTextStyle:
                          const TextStyle(fontSize: 18, color: Colors.black54),
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
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select Ringtone:',
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: _selectedRingtone,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRingtone = newValue!;
                        });
                      },
                      items: _ringtones.map((ringtone) {
                        return DropdownMenuItem(
                          value: ringtone,
                          child: Text(
                            ringtone,
                            style: const TextStyle(
                                color: Color(0xFF01161E)), // Rich black
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _onSetAlarmPressed,
                child: const Text('Set Alarm', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 20),
              if (_alarmTime != null)
                Text(
                  'Alarm Set For: $_alarmTime',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
