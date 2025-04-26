import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  bool _showRuns = true;


  @override
  void initState() {
    super.initState();
    _userID = FirebaseAuth.instance.currentUser?.email;

  }

  @override
  Widget build(BuildContext context) {
    CollectionReference runs = FirebaseFirestore.instance.collection('user_data/$_userID/runs');
    CollectionReference exercises = FirebaseFirestore.instance.collection('user_data/$_userID/lifts');

    return Scaffold(
      backgroundColor: Color(0xFFEFF6E0),
      body: Column(
        children: [

          // NEW: Toggle Buttons
          Padding(

            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              isSelected: [_showRuns, !_showRuns],
              onPressed: (int index) {
                setState(() {
                  _showRuns = index == 0;
                });
              },
              selectedColor: Colors.white,
              fillColor: Color(0xFF124559),
              borderColor: Color(0xFF124559),
              selectedBorderColor: Color(0xFF124559),
              borderRadius: BorderRadius.circular(10),
              children: const [

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Cardio'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Lifts'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: _showRuns ? runs.get() : exercises.get(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!;
                if (data.docs.isEmpty) {
                  return Center(
                    child: Text(_showRuns ? "No runs found." : "No lifts found."),
                  );
                }

                return ListView(
                  children: data.docs.map((DocumentSnapshot document) {
                    final docData = document.data() as Map<String, dynamic>;

                    if (_showRuns) {
                      // Display a Run
                      return ListTile(
                        title: Text(docData['run'].toString()),
                        subtitle: Text(
                          '${docData['distance'] != null ? 'Distance: ${docData['distance']} Miles | ' : ''}'
                              'Time: ${docData['time']} Minutes'
                              '${docData['distance'] != null ? '\nAverage MPH: ${(docData['distance'] / (docData['time'] / 60)).toStringAsFixed(2)}' : ''}',
                        ),
                      );
                    } else {
                      // Display a Lift
                      return ListTile(
                        title: Text(docData['exercise']),
                        subtitle: Text(
                          'Weight: ${docData['weight']} lbs\n'
                              'Reps: ${docData['reps']}\n'
                              'Sets: ${docData['sets']}',
                        ),
                      );
                    }
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}