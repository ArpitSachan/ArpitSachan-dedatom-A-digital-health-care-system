import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/main.dart';
import 'package:flash_chat/profiles/doctor_profile.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
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


class DoctorsList extends StatefulWidget {
  final String placeName;
  final String currentUserId;
  DoctorsList({@required this.placeName, this.currentUserId});

  @override
  State createState() => DoctorsListState(placeName: placeName, currentUserId: currentUserId);
}

class DoctorsListState extends State<DoctorsList> {
  DoctorsListState({@required this.placeName, this.currentUserId});

  final String placeName;
  final String currentUserId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Color(0xFF162447),
        ),
        backgroundColor: Colors.white,
        title: Text(
          '$placeName',
          style: TextStyle(color: Color(0xFF162447),
              fontFamily: 'NotoSans',
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
        IconButton(
            icon: Icon(Icons.add),
            color: Color(0xFF162447),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(type: 'Doctor', placeCollection: placeName,)));
            },
          )
        ],
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            Container(
              child: StreamBuilder(
                stream: Firestore.instance.collection('$placeName').document('doctors').collection('doctors').snapshots(),
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
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorProfile(type: 'doctor', placeName: placeName, accountId: document['id'], accountImage: document['photoUrl'], accountName: document['name'], currentUserId: currentUserId)));
            print(currentUserId);
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