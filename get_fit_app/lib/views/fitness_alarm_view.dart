import 'dart:async';
import 'package:flutter/material.dart';

class AlarmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Alarm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AlarmView(), // The main screen
    );
  }
}

/// stateful widget because screen content update over time
class AlarmView extends StatefulWidget {
  @override
  _AlarmViewState createState() => _AlarmViewState();
}


class _AlarmViewState extends State<AlarmView> {
  String _currentTime = '';
  Timer? _timer;

  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();

  String? _alarmTime;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    final formattedTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    setState(() {
      _currentTime = formattedTime;
    });
  }

  void _setAlarm() {
    final hour = _hourController.text;
    final minute = _minuteController.text;

    if (hour.isEmpty || minute.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both hour and minute')),
      );
      return;
    }

    setState(() {
      _alarmTime = '${hour.padLeft(2, '0')}:${minute.padLeft(2, '0')}';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alarm set for $_alarmTime')),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
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
            Text(
              'Current Time:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              _currentTime,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
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
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _setAlarm,
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