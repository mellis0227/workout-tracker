import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  int _selectedValue = 0;
  late DateTime date = DateTime(2025, 4, 15);
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final dateController = TextEditingController();
  final heightFeetController = ScrollController();

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<String?> openHeightDialog(BuildContext context) => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('Height'),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: 'Enter your height (feet)'),
              controller: _heightController,
            ),
            actions: [
              TextButton(
                child: Text('SUBMIT'),
                onPressed: submitHeight,
              )
            ]),
      );

  Future<String?> openWeightDialog(BuildContext context) => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('Weight'),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: 'Enter your height (lbs)'),
              controller: _weightController,
            ),
            actions: [
              TextButton(
                child: Text('SUBMIT'),
                onPressed: submitWeight,
              )
            ]),
      );

  void submitHeight() {
    Navigator.of(context).pop(_heightController.text);
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
            Column(children: <Widget>[
              SizedBox(
                height: 10,
              ),
              CircleAvatar(
                minRadius: 60.0,
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage(
                      'assets/images/luke-chesser-PHtp0cDBJSM-unsplash.jpg'),
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
                    child: Text(
                      'Birthday',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  subtitle: Text('${date.month}/${date.day}/${date.year}',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ))),
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
                  subtitle: Text(height,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ))),
              Container(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                    child: Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () => showCupertinoModalPopup(
                        context: context,
                        builder: (_) => SizedBox(
                            width: double.infinity,
                            height: 400,
                            child: CupertinoPicker(
                              backgroundColor: Colors.white,
                              itemExtent: 10,
                              scrollController: FixedExtentScrollController(
                                initialItem: 1,
                              ),
                              children: const [
                                Text('0'),
                                Text('1'),
                                Text('2'),
                                Text('3'),
                                Text('4'),
                                Text('5'),
                                Text('6'),
                                Text('7'),
                                Text('8'),
                                Text('9'),
                                Text('10'),
                              ],
                              onSelectedItemChanged: (int value) {
                                setState(() {
                                  _selectedValue = value;
                                });
                              },
                            )))),
              ),
              Divider(),
              ListTile(
                  title: Center(
                      child: Text('Weight',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ))),
                  subtitle: Text(weight + ' lbs',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ))),
              ElevatedButton(
                  child: Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () async {
                    final weight = await openWeightDialog(context);
                    if (weight == null || weight.isEmpty) return;

                    setState(() => this.weight = weight);
                  }),
              Divider(),
            ])
          ],
        ));
  }
}
