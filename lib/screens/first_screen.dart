import 'package:flash_chat/bmi_calculator/homeBMI.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/hospital_finder/home_finder.dart';
import 'package:flash_chat/profiles/doctor_profile.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class FirstScreen extends StatefulWidget {

  final String currentUserId;
  final String type;
  final String placeName;
  FirstScreen({@required this.currentUserId, @required this.type, @required this.placeName});
  @override
  _FirstScreenState createState() => _FirstScreenState(currentUserId: currentUserId, type: type);
}

class _FirstScreenState extends State<FirstScreen> {
  final String currentUserId;
  final String type;
  final String placeName;
  _FirstScreenState({@required this.currentUserId, @required this.type, @required this.placeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Center(
              child: RoundedButton(
                title: 'deatom Chat',
                colour: Colors.blueAccent,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(currentUserId: currentUserId, type: type, placeName: placeName)));
                },
              ),
            ),
            Center(
              child: RoundedButton(
                title: 'deatom Map',
                colour: Colors.blueAccent,

                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => App(currentUserId: currentUserId)));
                },
              ),
            ),
            Center(
              child: RoundedButton(
                title: 'deatom BMI',
                colour: Colors.blueAccent,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BMICalculator()));
                },
              ),
            ),
//            Center(
//              child: RoundedButton(
//                title: 'deatom Profile',
//                colour: Colors.blueAccent,
//                onPressed: () {
//                  Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorProfile()));
//                },
//              ),
//            ),
          ],
        ),
      ),


    );
  }
}
