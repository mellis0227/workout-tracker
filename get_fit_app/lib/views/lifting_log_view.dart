import 'package:flutter/material.dart';
import '../viewmodel/lifting_log_model.dart';
import '../presenter/lifting_log_presenter.dart';

class LiftingLogView extends StatelessWidget {
  const LiftingLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise Log',
      home: LiftingLog(),
    );
  }
}

class LiftingLog extends StatefulWidget {
  const LiftingLog({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LiftingLog> {
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();

  final LiftingLogPresenter _presenter = LiftingLogPresenter();

  void _logExercise() {
    if (
    _exerciseController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _setsController.text.isEmpty ||
        _repsController.text.isEmpty
    ) {
      return;
    }

    Exercise exercise = Exercise(
      exercise: _exerciseController.text,
      weight: int.tryParse(_weightController.text) ?? 0,
      sets: int.tryParse(_setsController.text) ?? 0,
      reps: int.tryParse(_repsController.text) ?? 0, id: '',
    );

    _presenter.logExercise(exercise);

    _exerciseController.clear();
    _weightController.clear();
    _setsController.clear();
    _repsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Log'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Exercise"),
                  TextField(
                    controller: _exerciseController,
                    decoration: InputDecoration(
                      labelText: 'Enter exercise here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Weight"),
                  TextField(
                    controller: _weightController,
                    decoration: InputDecoration(
                      labelText: 'Enter weight here (lbs)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Reps"),
                  TextField(
                    controller: _repsController,
                    decoration: InputDecoration(
                      labelText: 'Enter reps here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Sets"),
                  TextField(
                    controller: _setsController,
                    decoration: InputDecoration(
                      labelText: 'Enter sets here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _logExercise,
                    child: Text('Log Exercise'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    )
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Transform.scale(
                scale: 1.5,
              child: IconButton(
                icon: Icon(Icons.home),
                color: Colors.blue,
                onPressed: () => print('Home pressed'),
              ),
              ),
              Transform.scale(
                scale: 1.5,
              child: IconButton(
                icon: Icon(Icons.auto_graph),
                color: Colors.blue,
                onPressed: () => print('Activity pressed'),
              ),
              ),
              Transform.scale(
                scale: 1.5,
              child: IconButton(
                icon: Icon(Icons.alarm),
                color: Colors.blue,
                onPressed: () => print('Schedule pressed'),
              ),
              ),
              Transform.scale(
                scale: 1.5,
              child: IconButton(
                icon: Icon(Icons.person),
                color: Colors.blue,
                onPressed: () => print('Profile pressed'),
              ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
