import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';
import 'package:ruler_slider/ruler_slider.dart';

/* Profile page/code is unfinished and very clunky right now, merging to main to
meet sprint requirements
 */

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
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Profile> {
  String text = '';
  String height = '';
  String weight = '';
  int selectedItemIndex = 0;
  int selectedFeet = 0;
  int selectedInches = 0;
  double selectedWeight = 0.0;
  late DateTime date = DateTime(2025, 4, 15);
  final TextEditingController _weightController = TextEditingController();
  final dateController = TextEditingController();

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _weightController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void _openHeightPickerDialog(BuildContext context) {
    showModalBottomSheet(
    context: context,
    builder: (context) => SizedBox(
        height: 400,
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: WheelPicker(
              itemCount: 9,
              builder: (context, index) => Text("${index} ft", style:
              TextStyle(fontSize: 30.0)),
              selectedIndexColor: Colors.blue,
              onIndexChanged: (index, _) {
                setState(() {
                  selectedFeet = index;
                });
              },
              style: WheelPickerStyle(
                itemExtent: 40.0,
                squeeze: 1.25,
                diameterRatio: 0.9,
                surroundingOpacity: 0.25,
              )
            ),
          ),
          Expanded(
            child: WheelPicker(
              itemCount: 12,
              builder: (context, index) => Text("$index in", style:
              TextStyle(fontSize: 30.0)),
              selectedIndexColor: Colors.blue,
              onIndexChanged: (index, _) {
                setState(() {
                  selectedInches = index;
                });
              },
              style: WheelPickerStyle(
                itemExtent: 40,
                squeeze: 1.25,
                diameterRatio: 0.9,
                surroundingOpacity: 0.25,
              )
            ),
          ),
        Column(
        children: [
          TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel',
          style: TextStyle(fontSize: 20.0)),
        ),
        SizedBox(height: 150),
        TextButton(
          onPressed: () {
            setState(() {
              height = "$selectedFeet ft $selectedInches in";
            });
            Navigator.pop(context);
          },
          child: const Text("OK",
          style: TextStyle(fontSize: 20.0)),
        ),],),
      ],
    ),
    ),
  );
  }

  void _openWeightDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RulerSlider(
              minValue: 0.0,
              maxValue: 1000.0,
              initialValue: 100.0,
              rulerHeight: 100.0,
              selectedBarColor: Colors.grey,
              unselectedBarColor: Colors.grey,
              tickSpacing: 30.0,
              valueTextStyle: TextStyle(color: Colors.blue, fontSize: 18),
              onChanged: (double value) {
                setState(() {
                  selectedWeight = value;
                });
              },
              showFixedBar: true,
              fixedBarColor: Colors.blue,
              fixedBarWidth: 3.0,
              fixedBarHeight: 40.0,
              showFixedLabel: true,
              fixedLabelColor: Colors.blue,
              scrollSensitivity: 3.0,
              enableSnapping: true,
              majorTickInterval: 5,
              labelInterval: 1,
              labelVerticalOffset: 30.0,
              showBottomLabels: true,
              labelTextStyle: TextStyle(color: Colors.black, fontSize: 12),
              majorTickHeight: 20.0,
              minorTickHeight: 10.0,
            ),
            SizedBox(height: 20), // Space between buttons
            TextButton(
              onPressed: () {
                setState(() {
                  weight = "$selectedWeight lbs";
                });
                Navigator.pop(context);
              },
              child: const Text(
                "OK",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            SizedBox(height: 20), // Space between slider and buttons
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitWeight() {
    Navigator.of(context).pop(_weightController.text);
  }

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
                Column(
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
                            color: Colors.blue,
                          )),
                      Text('Your Name',
                          style: TextStyle(
                            color: Colors.blue,
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
                              '${date.month}/${date.day}/${date.year}',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                              )
                          )
                      ),
                      Builder(
                        builder: (context) {
                          return ElevatedButton(
                            child: Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );
                              if (newDate == null) return;
                              setState(() => date = newDate);
                            },
                          );
                        },
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
                              height,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                              )
                          )
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                      child:
                      ElevatedButton(
                        child: Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                          onPressed: () => _openHeightPickerDialog(context),
                      ),
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
                              weight,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                              )
                          )
                      ),
                      ElevatedButton(
                          child: Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () => _openWeightDialog(context),
                      ),
                      Divider(),
                    ]
                )
          ],
        )
    );
  }
}