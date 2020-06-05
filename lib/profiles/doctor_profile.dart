import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash_chat/bmi_calculator/icon_content.dart';
import 'package:flash_chat/bmi_calculator/reusable.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../settings.dart';

class DoctorProfile extends StatefulWidget {
  final String accountId;
  final String accountImage;
  final String accountName;
  final String type;
  final String placeName;
  final String currentUserId;
  DoctorProfile({@required this.type, this.placeName,  @required this.accountId, @required this.accountImage, @required this.accountName, @required this.currentUserId});
  @override
  _DoctorProfileState createState() => _DoctorProfileState(type: type, placeName: placeName, accountId: accountId, accountImage: accountImage, accountName: accountName, currentUserId: currentUserId);
}

class _DoctorProfileState extends State<DoctorProfile> {
  final String accountId;
  final String accountImage;
  final String accountName;
  final String type;
  final String placeName;
  final String currentUserId;
  _DoctorProfileState({@required this.type, this.placeName, @required this.accountId, @required this.accountImage, @required this.accountName, @required this.currentUserId});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black87,
        ),
        title: Text('Profile', style: TextStyle(color: Colors.black87),),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black87,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Settings(type: type, placeName: placeName,)));
              print(accountImage);
            },
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                width: 100.0,
                height: 100.0,
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage('$accountImage'),
                ),
              ),
              Container(
                child: Text('$accountName',
                style: TextStyle(
                  fontFamily: 'NotoSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
                ),
                ),
              ),
              Container(
                child: Text('Pediatrician',
                  style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                  ),),
              ),
              SizedBox(height: 60.0,),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ReusableCard(
                      onPress: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
                          displayId: accountId,
                          displayImage: accountImage,
                          currentUserId: currentUserId,
                          name: accountName,
                        )));
                      },
                      colour: Colors.white70,
                      cardChild: IconContent(
                        icon: Icons.chat, label: 'Chat',
                      ),
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      onPress: (){},
                      colour: Colors.white70,
                      cardChild: IconContent(
                        icon: Icons.book, label: 'Book Appointment',
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ReusableCard(
                      onPress: (){},
                      colour: Colors.white70,
                      cardChild: IconContent(
                        icon: Icons.phone, label: 'Call',
                      ),
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      onPress: (){},
                      colour: Colors.white70,
                      cardChild: IconContent(
                        icon: Icons.mail, label: 'Mail',
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )

    );
  }
}
