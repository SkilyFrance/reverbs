import 'dart:ui';

import 'package:SONOZ/inscriptionProcess/landingPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MyProfilePage extends StatefulWidget {



  MyProfilePage({Key key}) : super(key: key);


  @override
  MyProfilePageState createState() => MyProfilePageState();
}

class MyProfilePageState extends State<MyProfilePage> {


  //SignOutMethod
  signOut() {
    FirebaseAuth.instance.signOut().then((value) =>
        Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(builder: (context) => new LandingPage()),
            (_) => false));
  }



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return new Scaffold(
      backgroundColor: Colors.black,
      body: new NestedScrollView(
        scrollDirection: Axis.vertical,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget> [
            new CupertinoSliverNavigationBar(
              actionsForegroundColor: Colors.deepPurpleAccent,
              previousPageTitle: 'Home',
              automaticallyImplyTitle: true,
              automaticallyImplyLeading: true,
              transitionBetweenRoutes: true,
              backgroundColor: Colors.black.withOpacity(0.7),
              largeTitle: new Text('My settings',
                  style: new TextStyle(color: Colors.white),
                  ),
              trailing: new Material(
                color: Colors.transparent, 
                child: new IconButton(
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                icon: new Icon(Icons.login_outlined, color: Colors.grey, size: 25.0),
                onPressed: () {
                            final act = new CupertinoActionSheet(
                                title: new Text('Quit Reverbs now ?',
                                style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.bold),
                                ),
                                message: new Text('Be sure your want to quit.',
                                style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.w500),
                                ),
                                actions: <Widget>[
                                  new CupertinoActionSheetAction(
                                    child: new Text('Yes, want to quit', style: new TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      signOut();
                                    },
                                  ),
                                  new CupertinoActionSheetAction(
                                    child: new Text('No, want to stay'),
                                    onPressed: () {
                                      print('pressed');
                                    },
                                  ),
                                ],
                                cancelButton: new CupertinoActionSheetAction(
                                  child: new Text('Cancel',
                                  style: new TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ));
                            showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) => act);
                },
                ),
                ),
            ),
          ];
        }, 
        body: new Container(
          child: new SingleChildScrollView(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  height: MediaQuery.of(context).size.height*0.12,
                  width: MediaQuery.of(context).size.height*0.12,
                  decoration: new BoxDecoration(
                    color: Colors.grey[900].withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: new ClipOval(
                    child: new Image.asset('lib/assets/userPhoto.png',
                    fit: BoxFit.cover,
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.04,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  child: new Center(
                    child: new Text('David Morillo',
                    style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.04,
                  width: MediaQuery.of(context).size.width,
                ),
                //Divider
                new Container(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.height*0.05,
                          decoration: new BoxDecoration(
                            color: Colors.grey[900].withOpacity(0.7),
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          child: new Center(
                            child: new Image.asset('lib/assets/instagram.png',
                            height: 25.0,
                            width: 25.0,
                            color: Colors.white,
                            ),
                          ),
                        ),
                        //Divider
                        new Container(
                          height: MediaQuery.of(context).size.height*0.02,
                          width: MediaQuery.of(context).size.width*0.03,
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.height*0.05,
                          decoration: new BoxDecoration(
                            color: Colors.grey[900].withOpacity(0.7),
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          child: new Center(
                            child: new Image.asset('lib/assets/spotify.png',
                            height: 25.0,
                            width: 25.0,
                            color: Colors.white,
                            ),
                          ),
                        ),
                        //Divider
                        new Container(
                          height: MediaQuery.of(context).size.height*0.02,
                          width: MediaQuery.of(context).size.width*0.03,
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.height*0.05,
                          decoration: new BoxDecoration(
                            color: Colors.grey[900].withOpacity(0.7),
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          child: new Icon(Icons.shopping_bag_outlined),
                        ),
                      ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}