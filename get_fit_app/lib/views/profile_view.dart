import 'package:flutter/material.dart';
import 'dart:async';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      home: Profile(),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

void editEntry(){}

class _MyHomePageState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.tealAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.5, 0.9],
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10,),
              CircleAvatar(
              minRadius: 60.0,
              child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage('assets/images/luke-chesser-PHtp0cDBJSM-unsplash.jpg'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('@username',
            style: TextStyle(
              color: Colors.white,
            )),
            Text('Your Name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Center(
                child: Text('Birthday',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                    ),
                ),
                ),
                subtitle: Text(
                    'May 31st, 2005',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                    )
                )
          ),
            ElevatedButton(
              onPressed: editEntry,
              child: Text('Edit'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              )
            ),
            Divider(),
            ListTile(
              title: Center(
                child: Text('Height',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                    )),
              ),
              subtitle: Text(
                '8 ft 3 in',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                )
              )
            ),
            ElevatedButton(
              onPressed: editEntry,
              child: Text('Edit'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              )
            ),
            Divider(),
            ListTile(
              title: Center(
                  child: Text('Weight',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,)
                  )
              ),
              subtitle: Text(
                '25 lbs',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                )
              )
            ),
                ElevatedButton(
                  onPressed: editEntry,
                  child: Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  )
                ),
                Divider(),
        ]
      )
      ),
      ],
      )
    );
  }
}