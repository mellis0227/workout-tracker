import 'package:flutter/material.dart';
import '../presenter/fitness_alarm_presenter.dart';
import 'package:audioplayers/audioplayers.dart';

class AlarmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Alarm',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AlarmView(),
    );
  }
}

class AlarmView extends StatefulWidget {
  @override
  _AlarmViewState createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> implements AlarmViewContract {
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
      SnackBar(content: Text('Alarm is ringing!')),
    );
  }

  void _onSetAlarmPressed() {
     _presenter.setAlarm(
      _hourController.text,
      _minuteController.text,
      _selectedRingtone,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness Alarm'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Current Time:', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text(_currentTime,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            SizedBox(height: 40),
            TextField(
              controller: _hourController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Hour (0-23)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _minuteController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Minute (0-59)',
                border: OutlineInputBorder(),
              ),
            ),

            Text('Select Ringtone:', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: _selectedRingtone,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRingtone = newValue!;
                });
              },
              items: _ringtones.map((ringtone) {
                return DropdownMenuItem(
                  value: ringtone,
                  child: Text(ringtone),
                );
              }).toList(),
            ),


            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _onSetAlarmPressed,
              child: Text('Set Alarm'),
            ),
            SizedBox(height: 20),
            if (_alarmTime != null)
              Text(
                'Alarm Set For: $_alarmTime',
                style: TextStyle(fontSize: 18, color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}