import 'package:flutter/material.dart';
import 'package:get_fit_app/views/running_log_view.dart';
import 'lifting_log_view.dart';

void main() {
  runApp(activityLog()); // Runs the app and initializes the activity log screen
}

class activityLog extends StatelessWidget {
  const activityLog({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Log', // Title of the app
      home: ActivityLog(), // Initial screen of the app
    );
  }
}

class ActivityLog extends StatefulWidget {
  const ActivityLog({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ActivityLog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose your activity'), // AppBar title
        centerTitle: true, // Centers the title
      ),
      body: Center(
        child: Column(
          children: [
            // Button to navigate to the Weight Lifting log screen
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LiftingLog()),
                );
              },
              child: Text('Weight Lifting'),
            ),
            // Button to navigate to the Running/Walking log screen
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const runningLog()),
                );
              },
              child: Text('Run/Walk'),
            ),
          ],
        ),
      ),
    );
  }
}
