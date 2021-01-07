import 'package:SONOZ/inscriptionProcess/landingPage.dart';
import 'package:SONOZ/inscriptionProcess/profileCreation.dart';
import 'package:SONOZ/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) { 
    User user = FirebaseAuth.instance.currentUser;
    if(user == null) {
      print('no user recognize');
      Navigator.pushReplacement(context, new PageRouteBuilder(pageBuilder: (_,__,___) => new LandingPage()));
    } else {
      FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) {
          if(value.exists) {
            Navigator.pushReplacement(context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
            new NavigationPage(
              currentUser: user.uid, 
              currentUserType: value.data()['iam'],
              currentUserUsername: value.data()['userName'],
              currentUserPhoto: value.data()['profilePhoto'],
              )));
          } else {
            //Value No exist
            Navigator.pushReplacement(
              context, new PageRouteBuilder(pageBuilder: (_,__,___) => 
              new ProfileCreationProcessPage(currentUser: user.uid, currentUserEmail: user.email)));
          }
        }).catchError((error) => print(error));
    }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: new Center(
        child: new Container(
          color: Colors.black,
          child: Text(""),
        ),
      ),
    );
  }
}