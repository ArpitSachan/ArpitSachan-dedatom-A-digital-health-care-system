import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'first_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  final String type;
  final String placeCollection;
  LoginScreen({@required this.type, this.placeCollection});
  @override
  _LoginScreenState createState() => _LoginScreenState(type: type, placeCollection: placeCollection);
}

class _LoginScreenState extends State<LoginScreen> {
  final String placeCollection;
  final String type;
  _LoginScreenState({@required this.type, this.placeCollection});

  bool showSpinner = false;
  final auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email;
  String password;
  SharedPreferences prefs;
  bool isLoggedIn = false;
  FirebaseUser currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSignedIn();
  }
  void isSignedIn() async{
    this.setState(() {
      showSpinner =true;
    });
    prefs= await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if(isLoggedIn){
      Navigator.push(context, MaterialPageRoute(builder: (context) => FirstScreen(currentUserId: prefs.getString('id'),)));
    }

    this.setState(() {
      showSpinner=false;
    });
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      showSpinner=true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken);

    final FirebaseUser firebaseUser = (await auth.signInWithCredential(credential)).user;

    if(firebaseUser!=null) {
      if (type == 'User') {
        final QuerySnapshot result = await Firestore.instance.collection(
            'users')
            .where('id', isEqualTo: firebaseUser.uid)
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;

        if (documents.length == 0) {
          Firestore.instance.collection('users')
              .document(firebaseUser.uid)
              .setData({
            'name': firebaseUser.displayName,
            'photoUrl': firebaseUser.photoUrl,
            'id': firebaseUser.uid,
            'createdAt': DateTime
                .now()
                .millisecondsSinceEpoch
                .toString(),
            'chattingWith': null
          });

          currentUser = firebaseUser;
          await prefs.setString('id', currentUser.uid);
          await prefs.setString('name', currentUser.displayName);
          await prefs.setString('photoUrl', currentUser.photoUrl);
        }
        else {
          await prefs.setString('id', documents[0]['id']);
          await prefs.setString('name', documents[0]['displayName']);
          await prefs.setString('photoUrl', documents[0]['photoUrl']);
          await prefs.setString('aboutMe', documents[0]['aboutMe']);
        }
        Fluttertoast.showToast(msg: "Sign in success");
        this.setState(() {
          showSpinner = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            FirstScreen(currentUserId: prefs.getString('id'), type: type,)));
      }
      else{
        final QuerySnapshot result = await Firestore.instance.collection(
            '$placeCollection').document('doctors').collection('doctors')
            .where('id', isEqualTo: firebaseUser.uid)
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;

        if (documents.length == 0) {
          Firestore.instance.collection(
              '$placeCollection').document('doctors').collection('doctors')
              .document(firebaseUser.uid)
              .setData({
            'name': firebaseUser.displayName,
            'photoUrl': firebaseUser.photoUrl,
            'id': firebaseUser.uid,
            'createdAt': DateTime
                .now()
                .millisecondsSinceEpoch
                .toString(),
            'chattingWith': null,
            'hospital' : placeCollection
          });

          currentUser = firebaseUser;
          await prefs.setString('id', currentUser.uid);
          await prefs.setString('name', currentUser.displayName);
          await prefs.setString('photoUrl', currentUser.photoUrl);
        }
        else {
          await prefs.setString('id', documents[0]['id']);
          await prefs.setString('name', documents[0]['displayName']);
          await prefs.setString('photoUrl', documents[0]['photoUrl']);
          await prefs.setString('aboutMe', documents[0]['aboutMe']);
          await prefs.setString('hospital', documents[0]['hospital']);
        }
        Fluttertoast.showToast(msg: "Sign in success");
        this.setState(() {
          showSpinner = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            FirstScreen(currentUserId: prefs.getString('id'),type: type, placeName: placeCollection)));
      }
    }
    else{
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        showSpinner=false;
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              RoundedButton(
                title: 'Log In with Google',
                colour: Colors.lightBlueAccent,
                onPressed: ()
                {handleSignIn().then((FirebaseUser firebaseUser) => print(firebaseUser)).catchError((e)=>print(e));},
              ),
            ],
          ),
        ),
      ),
    );
  }
}