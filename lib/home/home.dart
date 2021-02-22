import 'package:SONOZ/Discover/projectPublication.dart';
import 'package:SONOZ/home/myprofile.dart';
import 'package:SONOZ/home/myprojects/fileshared.dart';
import 'package:SONOZ/home/myprojects/projectsSettings.dart';
import 'package:SONOZ/home/storage/demoTracks.dart';
import 'package:SONOZ/home/storage/releasedTracks.dart';
import 'package:SONOZ/home/storage/unreleasedTracks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share/share.dart';

import 'myprojects/projectInProgress.dart';

class HomePage extends StatefulWidget {

  String currentUser;
  String currentUserPhoto;
  String currentUserUsername;
  bool premiumVersion;

  HomePage({
    Key key, 
    this.currentUser, 
    this.currentUserPhoto,
    this.currentUserUsername,
    this.premiumVersion,
    }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {


  PageController _projectsPageViewController = new PageController(viewportFraction: 1, initialPage: 0);

  @override
  void initState() {
    _projectsPageViewController = new PageController(viewportFraction: 1, initialPage: 0);
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
              transitionBetweenRoutes: true,
              backgroundColor: Colors.black.withOpacity(0.3),
              largeTitle: new Text('Home',
                  style: new TextStyle(color: Colors.white),
                  ),
              trailing: new Material(
                color: Colors.transparent, 
                child: new IconButton(
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: new Icon(Icons.person, color: Colors.purpleAccent, size: 25.0),
                onPressed: () {
                  Navigator.push(context, new CupertinoPageRoute(fullscreenDialog: true, builder: (context) => new MyProfilePage(
                    currentUser: widget.currentUser,
                    currentUsername: widget.currentUserUsername,
                    currentUserPhoto: widget.currentUserPhoto,
                  )));
                },
                )),
            ),
          ];
        }, 
        body: new SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.03,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
              //Divider
              new Container(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Divider
                    new Container(
                      height: MediaQuery.of(context).size.height*0.02,
                      width: MediaQuery.of(context).size.width*0.05,
                      color: Colors.transparent,
                    ),
                    new Container(
                      child: new Text('Dashboard',
                      style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.03,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.20,
                width: MediaQuery.of(context).size.width*0.45,
                constraints: new BoxConstraints(
                  minHeight: 190.0,
                ),
                child: new StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').doc(widget.currentUser).collection('projects').snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return new Container(
                      );
                    }
                    if(snapshot.hasError) {
                      return new Container(
                          height: MediaQuery.of(context).size.height*0.10,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new Icon(Icons.wifi, size: 30.0, color: Colors.grey),
                              new Text('An error occured.',
                              style: new TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }

                    if(!snapshot.hasData || snapshot.data.documents.isEmpty) {
                    return new Padding(
                      padding: EdgeInsets.only(left: 0.0, right: 0.0),
                      child: new Container(
                        height: MediaQuery.of(context).size.height*0.28,
                        width: MediaQuery.of(context).size.width*0.45,
                        decoration: new BoxDecoration(
                          color: Colors.grey[900].withOpacity(0.5),
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: new Stack(
                          children: [
                        new Positioned(
                        top: 0.0,
                        left: 0.0,
                        right: 0.0,
                        bottom: 0.0,
                        child: new Container(
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(10.0),
                            color: Colors.grey[900].withOpacity(0.5),
                          ),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new IconButton(
                                icon: new Icon(Icons.add_box_rounded, size: 45.0, color: Colors.white), 
                                onPressed: () {
                                  Navigator.push(context, new CupertinoPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => new ProjectPublicationPage(
                                      currentUser: widget.currentUser,
                                      currentUserPhoto: widget.currentUserPhoto,
                                      currentUserUsername: widget.currentUserUsername,
                                    )));
                                }),
                              new Text('Add your first project.',
                              style: new TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            );
             }


                    return new Padding(
                      padding: EdgeInsets.only(left: 0.0, right: 0.0),
                      child: new Container(
                        height: MediaQuery.of(context).size.height*0.20,
                       width: MediaQuery.of(context).size.width*0.45,
                        decoration: new BoxDecoration(
                          color: Colors.grey[900].withOpacity(0.5),
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            new Container(
                              height: MediaQuery.of(context).size.height*0.07,
                              width: MediaQuery.of(context).size.width*0.45,
                              color: Colors.transparent,
                              child: new Center(child: new Text('Project in progress',
                              style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                              ),
                              ),
                            ),
                            new Container(
                              height: MediaQuery.of(context).size.height*0.13,
                              width: MediaQuery.of(context).size.width*0.45,
                              color: Colors.transparent,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new InkWell(
                                    onTap: () {
                                      Navigator.push(context, new CupertinoPageRoute(
                                        builder: (context) => new ProjectInProgressPage(
                                          currentUser: widget.currentUser,
                                          currentUserPhoto: widget.currentUserPhoto,
                                          currentUserUsername: widget.currentUserUsername,
                                          lengthOfSnapshot: snapshot.data.documents.length,
                                          snapshotFromHome: snapshot,
                                      )));
                                    },
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                  child: new Container(
                                    height: MediaQuery.of(context).size.height*0.10,
                                    width: MediaQuery.of(context).size.height*0.10,
                                    decoration: new BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: new Border.all(
                                        width: 5.0,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                    ),
                                    child: new Center(
                                      child: new Text(snapshot.data.documents.length.toString(),
                                      style: new TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
    
          },
          ),
              ),
              widget.premiumVersion == true
              ? new Container(
                height: MediaQuery.of(context).size.height*0.20,
                width: MediaQuery.of(context).size.width*0.45,
                constraints: new BoxConstraints(
                  minHeight: 190.0,
                ),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(10.0),
                    gradient: new LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.grey[900].withOpacity(0.5), Colors.grey[900].withOpacity(0.5)]
                    )),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Container(
                          height: MediaQuery.of(context).size.height*0.07,
                          width: MediaQuery.of(context).size.width*0.45,
                          color: Colors.transparent,
                          child: new Center(child: new Text('Reverbs premium.',
                          style: new TextStyle(color: Colors.yellow, fontSize: 12.0, fontWeight: FontWeight.bold),
                          ),
                          ),
                        ),
                            new Container(
                              height: MediaQuery.of(context).size.height*0.13,
                              width: MediaQuery.of(context).size.width*0.45,
                              color: Colors.transparent,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                new Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                child: new Text('⭐',
                                style: new TextStyle(fontSize: 35.0),
                                )),
                                  new FlatButton(
                                    color: Colors.yellow[700],
                                    shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(5.0),
                                    ),
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onPressed: () {
                                    showBarModalBottomSheet(
                                      context: context, 
                                      builder: (context){
                                        return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter modalSetState) {
                                           return new Container(
                                           height: MediaQuery.of(context).size.height*0.50,
                                           width: MediaQuery.of(context).size.width,
                                           color: Color(0xFF181818),
                                           child: new Column(
                                             mainAxisAlignment: MainAxisAlignment.start,
                                             children: [
                                               new Container(
                                                 height: MediaQuery.of(context).size.height*0.02,
                                                 width: MediaQuery.of(context).size.width,
                                               ),
                                               new Container(
                                                 color: Colors.transparent,
                                                 child: new Center(
                                                   child: new Text('Reverbs premium',
                                                   style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                                                   ),
                                                 ),
                                               ),
                                               new Container(
                                                height: MediaQuery.of(context).size.height*0.40,
                                                width: MediaQuery.of(context).size.width,
                                                color: Colors.transparent,
                                                child: new Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    new Container(
                                                      height: MediaQuery.of(context).size.height*0.16,
                                                      width: MediaQuery.of(context).size.width,
                                                      child: new Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          new Container(
                                                            height: MediaQuery.of(context).size.height*0.16,
                                                            width: MediaQuery.of(context).size.width*0.30,
                                                            decoration: new BoxDecoration(
                                                              gradient: new LinearGradient(
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                                colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
                                                              ),
                                                              borderRadius: new BorderRadius.circular(10.0),
                                                            ),
                                                            child: new Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                new Text('Projects',
                                                                style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                                                ),
                                                                new Icon(Icons.check_circle_outline_rounded, size: 35.0, color: Colors.white),
                                                                new Text('Unlimited',
                                                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                         new Container(
                                                            height: MediaQuery.of(context).size.height*0.16,
                                                            width: MediaQuery.of(context).size.width*0.30,
                                                            decoration: new BoxDecoration(
                                                              gradient: new LinearGradient(
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                                colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
                                                              ),
                                                              borderRadius: new BorderRadius.circular(10.0),
                                                            ),
                                                            child: new Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                new Text('Messages',
                                                                style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                                                ),
                                                                new Icon(Icons.check_circle_outline_rounded, size: 35.0, color: Colors.white),
                                                                new Text('Unlimited',
                                                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                         new Container(
                                                            height: MediaQuery.of(context).size.height*0.16,
                                                            width: MediaQuery.of(context).size.width*0.30,
                                                            decoration: new BoxDecoration(
                                                              gradient: new LinearGradient(
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                                colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
                                                              ),
                                                              borderRadius: new BorderRadius.circular(10.0),
                                                            ),
                                                            child: new Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                new Text('Storage',
                                                                style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                                                ),
                                                                new Icon(Icons.check_circle_outline_rounded, size: 35.0, color: Colors.white),
                                                                new Text('Unlimited',
                                                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    new Container(
                                                      color: Colors.transparent,
                                                      child: new Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          new Padding(
                                                            padding: EdgeInsets.only(top: 10.0),
                                                          child: new Text('Get 1 more month ?',
                                                          style: new TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                                                          )),
                                                          new Padding(
                                                            padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                                                          child: new Text("More you share, more it's free.",
                                                          style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.normal),
                                                          )),
                                                        ],
                                                      ),
                                                    ),
                                                    new Padding(
                                                      padding: EdgeInsets.only(top: 10.0),
                                                    child: new FlatButton(
                                                      splashColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      color: Colors.deepPurpleAccent,
                                                      shape: new RoundedRectangleBorder(
                                                        borderRadius: new BorderRadius.circular(5.0),
                                                      ),
                                                      onPressed: () {
                                                        final RenderBox box = context.findRenderObject();
                                                        Share.share(
                                                          'https://testflight.apple.com/join/UrDA8giU',
                                                          subject: 'Hey, join me on Reverbs to discover & be connected with new electronic music producers. You just have to download TestFlight (An Apple app) to have an access on Reverbs 🚀, Think to put : ${widget.currentUserUsername} as a sponsor on your first connection. hope to see you.',
                                                          sharePositionOrigin: box.localToGlobal(Offset.zero)&box.size).whenComplete(() {
                                                            print('Ok');
                                                          });
                                                      }, 
                                                      child: new Text('INVITE',
                                                      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                                      ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                               ),
                                               ],
                                              ),
                                           );
                                          },
                                        );
                                      });
                                    }, 
                                    child: new Text('Share',
                                    style: new TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      ],
                    ),
              )
//////////// REVERBS NORMAL ////////////////////////////////////
///////////////////////////////////////////////////////////////
              : new Container(
                height: MediaQuery.of(context).size.height*0.20,
                width: MediaQuery.of(context).size.width*0.45,
                  decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.purpleAccent, Colors.deepPurpleAccent]
                    ),
                    //color: Colors.grey[900].withOpacity(0.5),
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                constraints: new BoxConstraints(
                  minHeight: 190.0,
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new Container(
                      height: MediaQuery.of(context).size.height*0.07,
                      width: MediaQuery.of(context).size.width*0.45,
                      color: Colors.transparent,
                      child: new Center(child: new Text('Get premium version',
                      style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                      ),
                      ),
                    ),
                    
                            new Container(
                              height: MediaQuery.of(context).size.height*0.13,
                              width: MediaQuery.of(context).size.width*0.45,
                              color: Colors.transparent,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                new Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                child: new Text('🚀',
                                style: new TextStyle(fontSize: 35.0),
                                )),
                                  new FlatButton(
                                    color: Colors.black,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(5.0),
                                    ),
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onPressed: () {
                                    showBarModalBottomSheet(
                                      context: context, 
                                      builder: (context){
                                        return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter modalSetState) {
                                           return new Container(
                                           height: MediaQuery.of(context).size.height*0.50,
                                           width: MediaQuery.of(context).size.width,
                                           color: Color(0xFF181818),
                                           child: new Column(
                                             mainAxisAlignment: MainAxisAlignment.start,
                                             children: [
                                               new Container(
                                                 height: MediaQuery.of(context).size.height*0.02,
                                                 width: MediaQuery.of(context).size.width,
                                               ),
                                               new Container(
                                                 color: Colors.transparent,
                                                 child: new Center(
                                                   child: new Text('Reverbs premium',
                                                   style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                                                   ),
                                                 ),
                                               ),
                                               new Container(
                                                height: MediaQuery.of(context).size.height*0.40,
                                                width: MediaQuery.of(context).size.width,
                                                color: Colors.transparent,
                                                child: new Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    new Container(
                                                      height: MediaQuery.of(context).size.height*0.16,
                                                      width: MediaQuery.of(context).size.width,
                                                      child: new Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          new Container(
                                                            height: MediaQuery.of(context).size.height*0.16,
                                                            width: MediaQuery.of(context).size.width*0.30,
                                                            decoration: new BoxDecoration(
                                                              gradient: new LinearGradient(
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                                colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
                                                              ),
                                                              borderRadius: new BorderRadius.circular(10.0),
                                                            ),
                                                            child: new Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                new Text('Projects',
                                                                style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                                                ),
                                                                new Icon(Icons.check_circle_outline_rounded, size: 35.0, color: Colors.white),
                                                                new Text('Unlimited',
                                                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                         new Container(
                                                            height: MediaQuery.of(context).size.height*0.16,
                                                            width: MediaQuery.of(context).size.width*0.30,
                                                            decoration: new BoxDecoration(
                                                              gradient: new LinearGradient(
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                                colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
                                                              ),
                                                              borderRadius: new BorderRadius.circular(10.0),
                                                            ),
                                                            child: new Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                new Text('Messages',
                                                                style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                                                ),
                                                                new Icon(Icons.check_circle_outline_rounded, size: 35.0, color: Colors.white),
                                                                new Text('Unlimited',
                                                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                         new Container(
                                                            height: MediaQuery.of(context).size.height*0.16,
                                                            width: MediaQuery.of(context).size.width*0.30,
                                                            decoration: new BoxDecoration(
                                                              gradient: new LinearGradient(
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                                colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
                                                              ),
                                                              borderRadius: new BorderRadius.circular(10.0),
                                                            ),
                                                            child: new Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                new Text('Storage',
                                                                style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                                                ),
                                                                new Icon(Icons.check_circle_outline_rounded, size: 35.0, color: Colors.white),
                                                                new Text('Unlimited',
                                                                style: new TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    new Container(
                                                      color: Colors.transparent,
                                                      child: new Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          new Padding(
                                                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                                          child: new Text("More you share, more it's free.",
                                                          style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                                                          )),
                                                          new Padding(
                                                            padding: EdgeInsets.only(top: 15.0),
                                                          child: new FutureBuilder(
                                                            future: FirebaseFirestore.instance.collection('users').doc(widget.currentUser).collection('invitationsSent').get(),
                                                            builder: (BuildContext context, snapshot){
                                                              if(snapshot.hasError){return new Container();}
                                                              if(!snapshot.hasData || snapshot.data.documents.isEmpty){
                                                                return new Text('Invite 5 producers friends.',
                                                                style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold));
                                                             }
                                                             return new Text('Invite ${5-(snapshot.data.documents.length)} producers friends.',
                                                             style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold));
                                                            })),
                                                        ],
                                                      ),
                                                    ),
                                                    new Padding(
                                                      padding: EdgeInsets.only(top: 10.0),
                                                    child: new FlatButton(
                                                      splashColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      color: Colors.deepPurpleAccent,
                                                      shape: new RoundedRectangleBorder(
                                                        borderRadius: new BorderRadius.circular(5.0),
                                                      ),
                                                      onPressed: () {
                                                        final RenderBox box = context.findRenderObject();
                                                        Share.share(
                                                          'https://testflight.apple.com/join/UrDA8giU',
                                                          subject: 'Hey, join me on Reverbs to discover & be connected with new electronic music producers. You just have to download TestFlight (An Apple app) to have an access on Reverbs 🚀, Think to put : ${widget.currentUserUsername} as a sponsor on your first connection. hope to see you.',
                                                          sharePositionOrigin: box.localToGlobal(Offset.zero)&box.size).whenComplete(() {
                                                            print('Ok');
                                                          });
                                                      }, 
                                                      child: new Text('INVITE',
                                                      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                                      ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                               ),
                                               ],
                                              ),
                                           );
                                          },
                                        );
                                      });
                                    }, 
                                    child: new Text('Get premium',
                                    style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  ],
                ),
              ),
                ],
              ),
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.05,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
              //Divider
              new Container(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Divider
                    new Container(
                      height: MediaQuery.of(context).size.height*0.02,
                      width: MediaQuery.of(context).size.width*0.05,
                      color: Colors.transparent,
                    ),
                    new Container(
                      child: new Text('My storage',
                      style: new TextStyle(color: Colors.grey, fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.03,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
              new Container(
                height: MediaQuery.of(context).size.height*0.25,
                width: MediaQuery.of(context).size.width*0.90,
                constraints: new BoxConstraints(
                  minHeight: 220.0,
                ),
                decoration: new BoxDecoration(
                  color: Colors.grey[900].withOpacity(0.5),
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new Container(
                      height: MediaQuery.of(context).size.height*0.07,
                      width: MediaQuery.of(context).size.width*0.90,
                      color: Colors.transparent,
                      // Relased track //
                      child: new ListTile(
                        onTap: () {
                          Navigator.push(
                            context, 
                            new CupertinoPageRoute(
                              builder: (context) => new ReleasedTracksPage(
                                currentUser: widget.currentUser,
                                currentUserPhoto: widget.currentUserPhoto,
                                currentUserUsername: widget.currentUserUsername,
                                )));
                        },
                        leading: new Container(
                          height: MediaQuery.of(context).size.height*0.045,
                          width: MediaQuery.of(context).size.height*0.045,
                          decoration: new BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          child: new Center(
                            child: new Icon(Icons.lock_open_rounded, color: Colors.white, size: 20.0),
                          ),
                        ),
                        title: new Text('Released tracks', style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        trailing: new Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 80.0),
                    child: new Divider(height: 2.0,color: Colors.grey[800])),
                    new Container(
                      height: MediaQuery.of(context).size.height*0.07,
                      width: MediaQuery.of(context).size.width*0.90,
                      color: Colors.transparent,
                      // Unreleased track//
                      child: new ListTile(
                        onTap: () {
                          Navigator.push(
                            context, 
                            new CupertinoPageRoute(
                              builder: (context) => new UnreleasedTracksPage(
                                currentUser: widget.currentUser,
                                currentUserPhoto: widget.currentUserPhoto,
                                currentUserUsername: widget.currentUserUsername,
                              )));
                        },
                        leading: new Container(
                          height: MediaQuery.of(context).size.height*0.045,
                          width: MediaQuery.of(context).size.height*0.045,
                          decoration: new BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          child: new Center(
                            child: new Icon(Icons.lock_rounded, color: Colors.white, size: 20.0),
                          ),
                        ),
                        title: new Text('Unreleased tracks', style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        trailing: new Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(left: 80.0),
                    child: new Divider(height: 2.0,color: Colors.grey[800])),
                    new Container(
                      height: MediaQuery.of(context).size.height*0.07,
                      width: MediaQuery.of(context).size.width*0.90,
                      color: Colors.transparent,
                      // Unreleased LISTILE //
                      child: new ListTile(
                        onTap: () {
                          Navigator.push(
                            context, 
                            new CupertinoPageRoute(
                              builder: (context) => new DemoTracksPage(
                                currentUser: widget.currentUser,
                                currentUserPhoto: widget.currentUserPhoto,
                                currentUserUsername: widget.currentUserUsername,
                              )));
                        },
                        leading: new Container(
                          height: MediaQuery.of(context).size.height*0.045,
                          width: MediaQuery.of(context).size.height*0.045,
                          decoration: new BoxDecoration(
                            color: Colors.lightBlue[800],
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          child: new Center(
                            child: new Icon(Icons.lock_rounded, color: Colors.white, size: 20.0),
                          ),
                        ),
                        title: new Text('Demo tracks', style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        trailing: new Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}