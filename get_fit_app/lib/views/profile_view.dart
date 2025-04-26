import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';
import 'package:ruler_slider/ruler_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../viewmodel/profile_model.dart';
import '../presenter/profile_presenter.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
  String? userID;
  String height = '';
  String weight = '';
  int selectedItemIndex = 0;
  int selectedFeet = 0;
  int selectedInches = 0;
  int selectedMeters = 0;
  int selectedCentimeters = 0;
  double selectedWeightLbs = 0.0;
  double selectedWeightKgs = 0.0;
  List<Widget> heightMetrics = <Widget>[Text('Ft'), Text('m')];
  List<Widget> weightMetrics = <Widget>[Text('Lbs'), Text('Kgs')];
  late DateTime date = DateTime(2025, 4, 15);
  final TextEditingController weightController = TextEditingController();
  final dateController = TextEditingController();
  List<bool> isHeightSelected = [true, false];
  List<bool> isWeightSelected = [true, false];
  Uint8List? _imageBytes;

  final ProfilePresenter _presenter = ProfilePresenter();

  @override
  void initState() {
    super.initState();
    userID = FirebaseAuth.instance.currentUser?.email;
    print("Current user ID: $userID");
  }

  // ?
  void saveProfileData() {
    ProfileData profileData = ProfileData(
      userID: userID ?? "",
      height: height,
      weight: weight,
      date: date,
    );
    _presenter.saveProfileData(userID!, profileData);
  }

  @override
  void dispose() {
    weightController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void _openHeightFtPickerDialog(BuildContext context) {
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
              selectedIndexColor: Color(0xFF598392),
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
              selectedIndexColor: Color(0xFF598392),
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

  void _openHeightMetersPickerDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 400,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: WheelPicker(
                  itemCount: 4,
                  builder: (context, index) => Text("${index}", style:
                  TextStyle(fontSize: 30.0)),
                  selectedIndexColor: Color(0xFF598392),
                  onIndexChanged: (index, _) {
                    setState(() {
                      selectedMeters = index;
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
                  itemCount: 10,
                  builder: (context, index) => Text(".$index", style:
                  TextStyle(fontSize: 30.0)),
                  selectedIndexColor: Color(0xFF598392),
                  onIndexChanged: (index, _) {
                    setState(() {
                      selectedCentimeters = index;
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
                      height = "$selectedMeters.$selectedCentimeters m";
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

  void _openWeightLbsDialog(BuildContext context) {
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
              valueTextStyle: TextStyle(color: Color(0xFF598392), fontSize: 18),
              onChanged: (double value) {
                setState(() {
                  selectedWeightLbs = value;
                });
              },
              showFixedBar: true,
              fixedBarColor: Color(0xFF598392),
              fixedBarWidth: 3.0,
              fixedBarHeight: 40.0,
              showFixedLabel: true,
              fixedLabelColor: Color(0xFF598392),
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
                  weight = "$selectedWeightLbs lbs";
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

  void _openWeightKgsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RulerSlider(
              minValue: 0.0,
              maxValue: 500.0,
              initialValue: 45.0,
              rulerHeight: 100.0,
              selectedBarColor: Colors.grey,
              unselectedBarColor: Colors.grey,
              tickSpacing: 30.0,
              valueTextStyle: TextStyle(color: Color(0xFF598392), fontSize: 18),
              onChanged: (double value) {
                setState(() {
                  selectedWeightKgs = value;
                });
              },
              showFixedBar: true,
              fixedBarColor: Color(0xFF598392),
              fixedBarWidth: 3.0,
              fixedBarHeight: 40.0,
              showFixedLabel: true,
              fixedLabelColor: Color(0xFF598392),
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
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  weight = "$selectedWeightKgs Kgs";
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

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final PickedImage = await picker.pickImage(source: ImageSource.gallery);

    if(PickedImage != null){
      final imageBytes = await PickedImage.readAsBytes();

      setState(() {
        _imageBytes = imageBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFEFF6E0),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 10),
            Stack(children: [
              CircleAvatar(
              minRadius: 60.0,
              backgroundColor: Color(0xFFAEC3B0),
              child: CircleAvatar(
                backgroundColor: Color(0xFFAEC3B0),
                  radius: 50.0,
                  backgroundImage: _imageBytes != null ? MemoryImage(_imageBytes!) : null,
                child: _imageBytes == null
                ? Icon(
                  Icons.person,
                  size: 70,
                  color: Color(0xFF598392),
                )
                 : null
              ),
            ),
            Positioned(
              right: 140,
              bottom: 10,
              child: InkWell(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFF124559),
                  child: Icon(Icons.edit,
                      color: Color(0xFFEFF6E0),
                      size: 20),
                ),
              ),
            ),],),
                Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text('Your Name',
                          style: TextStyle(
                            color: Color(0xFF124559),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(color: Color(0xFFAEC3B0)),
                      ListTile(
                          title: Center(
                            child: Text('Birthday',
                              style: TextStyle(
                                color: Color(0xFF124559),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Text(
                              '${date.month}/${date.day}/${date.year}',
                              style: TextStyle(
                                color: Color(0xFF598392),
                                fontSize: 20,
                              )
                          )
                      ),
                      Builder(
                        builder: (context) {
                          return ElevatedButton(
                            child: Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Color(0xFFAEC3B0),
                              backgroundColor: Color(0xFF124559),
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
                      Divider(color: Color(0xFFAEC3B0)),
                      ListTile(
                          title: Center(
                            child: Text('Height',
                                style: TextStyle(
                                  color: Color(0xFF124559),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          subtitle: Text(
                              height,
                              style: TextStyle(
                                color: Color(0xFF598392),
                                fontSize: 20,
                              )
                          )
                      ),
                      ToggleButtons(
                        isSelected: isHeightSelected,
                        onPressed: (int index) {
                          setState(() {
                            for(int buttonIndex = 0; buttonIndex < isHeightSelected.length; buttonIndex++){
                              if(buttonIndex == index) {
                                isHeightSelected[buttonIndex] = true;
                              }
                              else {
                                isHeightSelected[buttonIndex] = false;
                              }
                            }
                            if (index == 0) {
                              "$selectedFeet ft $selectedInches in";
                            }
                            else {
                              "$selectedMeters . $selectedCentimeters m";
                            }
                          });
                        },
                        children: heightMetrics,
                        color: Color(0xFFAEC3B0),
                        selectedColor: Color(0xFF124559),
                        fillColor: Color(0xFFAEC3B0),
                      ),
                      SizedBox(height: 20),
                      Container(
                      child:
                      ElevatedButton(
                        child: Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color(0xFFAEC3B0),
                          backgroundColor: Color(0xFF124559),
                        ),
                          onPressed: () {
                          if(isHeightSelected[0]) {
                            _openHeightFtPickerDialog(context);
                          }
                          else {
                            _openHeightMetersPickerDialog(context);
                          }
                        }
                      ),
                      ),
                      Divider(color: Color(0xFFAEC3B0)),
                      ListTile(
                          title: Center(
                              child: Text('Weight',
                                  style: TextStyle(
                                    color: Color(0xFF124559),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  )
                              )
                          ),
                          subtitle: Text(
                              weight,
                              style: TextStyle(
                                color: Color(0xFF598392),
                                fontSize: 20,
                              )
                          )
                      ),
                      ToggleButtons(
                        isSelected: isWeightSelected,
                        onPressed: (int index) {
                          setState(() {
                            for(int buttonIndex = 0; buttonIndex < isWeightSelected.length; buttonIndex++){
                              if(buttonIndex == index) {
                                isWeightSelected[buttonIndex] = true;
                              }
                              else {
                                isWeightSelected[buttonIndex] = false;
                              }
                            }
                            if (index == 0) {
                              "$selectedWeightLbs lbs";
                            }
                            else {
                              "$selectedWeightKgs Kgs";
                            }
                          });
                        },
                        children: weightMetrics,
                        color: Color(0xFFAEC3B0),
                        selectedColor: Color(0xFF124559),
                        fillColor: Color(0xFFAEC3B0),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                          child: Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color(0xFFAEC3B0),
                            backgroundColor: Color(0xFF124559),
                          ),
                          onPressed: () {
                           if (isWeightSelected[0]) {
                            _openWeightLbsDialog(context);
                           }
                           else {
                             _openWeightKgsDialog(context);
                           }
                           },
                      ),
                      ElevatedButton(
                        child: Text('Save Profile Data'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color(0xFFAEC3B0),
                          backgroundColor: Color(0xFF124559),
                        ),
                        onPressed: () {
                          saveProfileData();
                        }
                      ),
                    ]
                )
          ],
        )
    );
  }
}