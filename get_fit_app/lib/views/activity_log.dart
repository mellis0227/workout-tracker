import 'package:flutter/material.dart';
import 'package:get_fit_app/views/running_log_view.dart';
import 'lifting_log_view.dart';

void main() {
  runApp(activityLog());
}

class activityLog extends StatelessWidget {
  const activityLog({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Log',
      home: ActivityLog(),
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
        title: Text('Choose your activity'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LiftingLog()),
                );
              },
              child: Text('Weight Lifting'),
            ),
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
