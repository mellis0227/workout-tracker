import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'exercise_log_view.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _goal = '';
  String _exercise = '';
  int _reps = 0;
  int _sets = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Goal',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) => _goal = text,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Exercise',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) => _exercise = text,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Reps',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (text) => _reps = int.parse(text),
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Sets',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (text) => _sets = int.parse(text),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => print('Button pressed'),
              child: Text('Log Exercise'),
            ),
          ],
        ),
      ),
    );
  }
}