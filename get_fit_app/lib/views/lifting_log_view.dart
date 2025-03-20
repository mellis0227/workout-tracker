import 'package:flutter/material.dart';

// This is just a template, currently working on building up the UI

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise Log',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _goal = '';
  String _exercise = '';
  int _weight = 0;
  int _reps = 0;
  int _sets = 0;
  String _home = '';

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
                    decoration: InputDecoration(
                      labelText: 'Enter exercise here',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) => _exercise = text,
                  ),
                  SizedBox(height: 20),
                  Text("Weight"),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter weight here',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) => _weight = int.parse(text),
                  ),
                  SizedBox(height: 20),
                  Text("Reps"),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter reps here',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (text) => _reps = int.parse(text),
                  ),
                  SizedBox(height: 20),
                  Text("Sets"),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter sets here',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (text) => _sets = int.parse(text),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Log Exercise'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    )
                  ),
                  Column(

                    children: [
                      SizedBox(height: 20),
                      Text("Workout Summary", style: TextStyle(fontSize: 20.0),),
                    ],

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