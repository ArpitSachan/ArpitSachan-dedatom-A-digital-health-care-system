import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/main.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flash_chat/settings.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class HomeScreen extends StatefulWidget {
  final String currentUserId;
  final String type;
  final String placeName;
  HomeScreen({@required this.currentUserId, @required this.type, @required this.placeName});

  @override
  State createState() => HomeScreenState(currentUserId: currentUserId, type:  type, placeName: placeName);
}

class HomeScreenState extends State<HomeScreen> {
  final String type;
  final String placeName;
  HomeScreenState({@required this.currentUserId, @required this.type, @required this.placeName});

  final String currentUserId;

//  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
//  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool showSpinner = false;
  List<Option> options = const <Option>[
    const Option(title: 'Settings', icon: Icons.settings),
    const Option(title: 'Sign out', icon: Icons.exit_to_app)
  ];


  void onItemMenuPress(Option choice) {
    if (choice.title == 'Sign out') {
      handleSignOut();
    } else if(choice.title == 'Settings'){
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Settings(type: type, placeName : placeName)));
    }
  }

  Future<Null> onBackPress() async {
   Navigator.pop(context);
  }

  Future<Null> handleSignOut() async {
    this.setState(() {
      showSpinner = true;
    });

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context)=> WelcomeScreen()));
    this.setState(() {
      showSpinner = false;
    });

    Navigator.pushNamed(context, LoginScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Color(0xFF162447),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'dedatom_chat',
          style: TextStyle(color: Color(0xFF162447),
              fontFamily: 'NotoSans',
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Option>(
            icon: Icon(Icons.more_vert, color: Color(0xFF162447),),
            onSelected: onItemMenuPress,
    itemBuilder: (BuildContext context) {
              return options.map((Option choice) {
                return PopupMenuItem<Option>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          choice.icon,
                          color: Color(0xFF162447),
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          choice.title,
                          style: TextStyle(color: Color(0xFF162447)),
                        ),
                      ],
                    ));
              }).toList();
            },
          ),
        ],
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            Container(
              child: StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF162447)),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          buildItem(context, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                    );
                  }
                },
              ),
            ),

          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['id'] == currentUserId) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: document['photoUrl'] != null
                    ? CachedNetworkImage(
                  placeholder: (context, url) =>
                      Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF162447)),
                        ),
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.all(15.0),
                      ),
                  imageUrl: document['photoUrl'],
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                )
                    : Icon(
                  Icons.account_circle,
                  size: 50.0,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Expanded(
                child: Container(
                  width: 100.0,
                    height: 33.0,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Text(
                              '${document['name']}',
                              style: TextStyle(color: Color(0xFF162447),
                              fontSize: 20.0,
                                  fontFamily: 'NotoSans',
                              fontWeight: FontWeight.bold),
                            ),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                          ),
                        ),
                        
                      ],
                    ),
                    margin: EdgeInsets.only(left: 20.0),
                  ),
              ),

            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen(
                    displayId: document.documentID,
                    displayImage: document['photoUrl'],
                          currentUserId: currentUserId,
                          name: document['name'],
                        )));
            },
          color: Colors.grey.withOpacity(0.3),
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0)),
        ),
        margin: EdgeInsets.only(bottom: 5.0),

      );
    }
  }
}
class Option {
  const Option({this.title, this.icon});
  final String title;
  final IconData icon;
}