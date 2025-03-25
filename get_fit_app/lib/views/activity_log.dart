import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Log',
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

 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose your activity'),
        centerTitle: true,
      ),
      body: Center(
          child:  Column(
        //fortnite
            children:[
              
              ElevatedButton(
              onPressed: () => print('Button pressed'),
              child: Text('Weight Lifting'),
               ),
              ElevatedButton(
              onPressed: () => print('Button pressed'),
              child: Text('Run/Walk'),
               ),
              
              ]
              ,
        
        ),
               
       ),
       
          
      );
    
 }
}