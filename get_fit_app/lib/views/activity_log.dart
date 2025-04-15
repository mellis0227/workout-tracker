import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_fit_app/views/fitness_alarm_view.dart';
import 'package:get_fit_app/views/lifting_log_view.dart';
import 'package:get_fit_app/views/running_log_view.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
  String? _userID;

  @override
  void initState() {
    super.initState();
    _userID = FirebaseAuth.instance.currentUser?.email;
    print("Current user ID: $_userID");

  }

  @override
  Widget build(BuildContext context) {
    CollectionReference runs = FirebaseFirestore.instance.collection('user_data/$_userID/runs');

    return Scaffold(
      appBar: AppBar(title: Text("Activity Log")),
      body: FutureBuilder<QuerySnapshot>(
        future: runs.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          if (data.docs.isEmpty) {
            return const Center(child: Text("No runs found."));
          }

          return ListView(
            children: data.docs.map((DocumentSnapshot document) {
              final runData = document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(runData['run']?.toString() ?? 'Unnamed Run'),
                subtitle: Text(
                  'Distance: ${runData['distance']?.toString() ??
                      'N/A'} | Time: ${runData['time']?.toString() ?? 'N/A'}',
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
