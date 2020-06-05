import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  final String type;
  final String placeName;
  Settings({@required this.type, @required this.placeName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF162447),
        title: Text(
          'dedatom_settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SettingScreen(type: type, placeName: placeName,),
    );
  }
}

class SettingScreen extends StatefulWidget {
  final String type;
  final String placeName;
  SettingScreen({@required this.type, @required this.placeName});
  @override
  _SettingScreenState createState() => _SettingScreenState(type: type, placeName: placeName);
}

class _SettingScreenState extends State<SettingScreen> {
  final String type;
  final String placeName;
  _SettingScreenState({@required this.type, @required this.placeName});
  
  TextEditingController controllerName;
  TextEditingController controllerAboutMe;
  TextEditingController controllerHospital;

  SharedPreferences prefs;

  String id = '';
  String name = '';
  String aboutMe = '';
  String photoUrl = '';
  String hospital = '';

  bool showSpinner = false;
  var displayImage;

  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeAboutMe = FocusNode();
  final FocusNode focusNodeHospital = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readLocal();
  }

  void readLocal() async {
    if(type == 'User') {
      prefs = await SharedPreferences.getInstance();
      id = prefs.getString('id') ?? '';
      name = prefs.getString('name') ?? '';
      aboutMe = prefs.getString('aboutMe') ?? '';
      photoUrl = prefs.getString('photoUrl') ?? '';

      controllerAboutMe = TextEditingController(text: aboutMe);
      controllerName = TextEditingController(text: name);

      setState(() {});
    } else {
      prefs = await SharedPreferences.getInstance();
      id = prefs.getString('id') ?? '';
      name = prefs.getString('name') ?? '';
      aboutMe = prefs.getString('aboutMe') ?? '';
      photoUrl = prefs.getString('photoUrl') ?? '';
      hospital = prefs.getString('hospital');

      controllerAboutMe = TextEditingController(text: aboutMe);
      controllerName = TextEditingController(text: name);
      controllerHospital = TextEditingController(text: hospital);

      setState(() {});
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        displayImage = image;
        showSpinner = true;
      });
    }
    String fileName = id;
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference reference = storage.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(displayImage);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if(type == 'User') {
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
            photoUrl = downloadUrl;

            Firestore.instance.collection('users').document('id').updateData({
              'name': name,
              'aboutMe': aboutMe,
              'photoUrl': photoUrl
            }).then((data) async {
              await prefs.setString('photoUrl', photoUrl);
              setState(() {
                showSpinner = false;
              });
              Fluttertoast.showToast(msg: "Upload success");
            }).catchError((err) {
              setState(() {
                showSpinner = false;
              });
              Fluttertoast.showToast(msg: err.toString());
            });
          }, onError: (err) {
            setState(() {
              showSpinner = false;
            });
            Fluttertoast.showToast(msg: 'Please upload jpg/png/jpeg file only');
          });
        } else {
          setState(() {
            showSpinner = false;
          });
          Fluttertoast.showToast(msg: 'Please upload jpg/png/jpeg file only');
        }
      } else{
        if (value.error == null) {
          storageTaskSnapshot = value;
          storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
            photoUrl = downloadUrl;

            Firestore.instance.collection('$placeName').document('doctors').collection('doctors').document('id').updateData({
              'name': name,
              'aboutMe': aboutMe,
              'photoUrl': photoUrl,
              'hospital' : hospital
            }).then((data) async {
              await prefs.setString('photoUrl', photoUrl);
              setState(() {
                showSpinner = false;
              });
              Fluttertoast.showToast(msg: "Upload success");
            }).catchError((err) {
              setState(() {
                showSpinner = false;
              });
              Fluttertoast.showToast(msg: err.toString());
            });
          }, onError: (err) {
            setState(() {
              showSpinner = false;
            });
            Fluttertoast.showToast(msg: 'Please upload jpg/png/jpeg file only');
          });
        } else {
          setState(() {
            showSpinner = false;
          });
          Fluttertoast.showToast(msg: 'Please upload jpg/png/jpeg file only');
        }
      }
    }, onError: (err) {
      setState(() {
        showSpinner = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
    
  }


  void handleUpdateData() {
    if (type == 'User') {
      focusNodeName.unfocus();
      focusNodeAboutMe.unfocus();


      setState(() {
        showSpinner = true;
      });
      Firestore.instance.collection('users').document(id).updateData({
        'name': name,
        'aboutMe': aboutMe,
        'photoUrl': photoUrl
      }).then((data) async {
        await prefs.setString('name', name);
        await prefs.setString('aboutMe', aboutMe);
        await prefs.setString('photoUrl', photoUrl);

        setState(() {
          showSpinner = false;
        });
        Fluttertoast.showToast(msg: "Update success");
      }).catchError((err) {
        setState(() {
          showSpinner = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });
    } else {
      focusNodeName.unfocus();
      focusNodeAboutMe.unfocus();
      focusNodeHospital.unfocus();


      setState(() {
        showSpinner = true;
      });
      Firestore.instance.collection('$placeName').document('doctors').collection('doctors').document(id).updateData({
        'name': name,
        'aboutMe': aboutMe,
        'photoUrl': photoUrl,
        'hospital' : hospital
      }).then((data) async {
        await prefs.setString('name', name);
        await prefs.setString('aboutMe', aboutMe);
        await prefs.setString('photoUrl', photoUrl);
        await prefs.setString('hospital' , hospital);

        setState(() {
          showSpinner = false;
        });
        Fluttertoast.showToast(msg: "Update success");
      }).catchError((err) {
        setState(() {
          showSpinner = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (displayImage == null)
                          ? (photoUrl != ''
                              ? Material(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                      width: 90.0,
                                      height: 90.0,
                                      padding: EdgeInsets.all(20.0),
                                    ),
                                    imageUrl: photoUrl,
                                    width: 90.0,
                                    height: 90.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(45.0)),
                                  clipBehavior: Clip.hardEdge,
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 90.0,
                                  color: Colors.green,
                                ))
                          : Material(
                              child: Image.file(
                                displayImage,
                                width: 90.0,
                                height: 90.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Color(0xFF162447).withOpacity(0.5),
                        ),
                        onPressed: getImage,
                        padding: EdgeInsets.all(30.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.grey,
                        iconSize: 30.0,
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
              ),
              Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      'Name',
                      style: TextStyle(
                          fontFamily: 'NotoSans',
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,

                          color: Color(0xFF162447)),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Color(0xFF162447)),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Jon Doe',
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: controllerName,
                        onChanged: (value) {
                          name = value;
                        },
                        focusNode: focusNodeName,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                  Container(
                    child: Text(
                      'About me',
                      style: TextStyle(
                          fontFamily: 'NotoSans',
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF162447)),
                    ),
                    margin: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Color(0xFF162447)),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Fun, like travel and play PES...',
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: controllerAboutMe,
                        onChanged: (value) {
                          aboutMe = value;
                        },
                        focusNode: focusNodeAboutMe,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              Container(
                child: FlatButton(
                  onPressed: handleUpdateData,
                  child: Text(
                    'UPDATE',
                    style: TextStyle(fontSize: 16.0,
                        fontFamily: 'NotoSans',
                        fontWeight: FontWeight.bold),
                  ),
                  color: Color(0xFF162447),
                  highlightColor: Color(0xff8d93a0),
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                ),
                margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
        ),
        Positioned(
          child: showSpinner
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF8d93a0))),
                  ),
                  color: Colors.white.withOpacity(0.8),
                )
              : Container(),
        ),
      ],
    );
  }
}
