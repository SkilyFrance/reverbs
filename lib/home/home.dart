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

import 'myprojects/projectInProgress.dart';

class HomePage extends StatefulWidget {

  String currentUser;
  String currentUserPhoto;
  String currentUserUsername;

  HomePage({
    Key key, 
    this.currentUser, 
    this.currentUserPhoto,
    this.currentUserUsername,
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
                  Navigator.push(context, new CupertinoPageRoute(fullscreenDialog: true, builder: (context) => new MyProfilePage()));
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
                      child: new Text('My projects',
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
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.28,
                constraints: new BoxConstraints(
                  minHeight: 280.0,
                ),
                child: new StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').doc(widget.currentUser).collection('projects').snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return new Container(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            new CupertinoActivityIndicator(radius: 7.0, animating: true),
                            new Text('Fetching datas ...',
                            style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
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
                    if(!snapshot.hasData) {
                    return new Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: new Container(
                        height: MediaQuery.of(context).size.height*0.28,
                        width: MediaQuery.of(context).size.width*0.90,
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
                            color: Colors.black.withOpacity(0.9),
                          ),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new Text('Your project management tool',
                              style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                              ),
                              new IconButton(
                                icon: new Icon(Icons.add_box_rounded, size: 40.0, color: Colors.white), 
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
                              style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
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

                    if(snapshot.data.documents.isEmpty) {
                    return new Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: new Container(
                        height: MediaQuery.of(context).size.height*0.28,
                        width: MediaQuery.of(context).size.width*0.90,
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
                            color: Colors.black.withOpacity(0.9),
                          ),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new Text('Your project management tool',
                              style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                              ),
                              new IconButton(
                                icon: new Icon(Icons.add_box_rounded, size: 40.0, color: Colors.white), 
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
                              style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
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
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: new Container(
                        height: MediaQuery.of(context).size.height*0.28,
                        width: MediaQuery.of(context).size.width*0.90,
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
                              child: new Center(child: new Text('Project in progress',
                              style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                              ),
                              ),
                            ),
                            new Container(
                              height: MediaQuery.of(context).size.height*0.20,
                              width: MediaQuery.of(context).size.width*0.90,
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
                                    height: MediaQuery.of(context).size.height*0.15,
                                    width: MediaQuery.of(context).size.height*0.15,
                                    decoration: new BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: new Border.all(
                                        width: 5.0,
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                    child: new Center(
                                      child: new Text(snapshot.data.documents.length.toString(),
                                      style: new TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  ),
                                  /*new Container(
                                    height: MediaQuery.of(context).size.height*0.07,
                                    width: MediaQuery.of(context).size.width*0.90,
                                    color: Colors.transparent,
                                    // Project in progress LISTILE //
                                    child: new ListTile(
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
                                      leading: new Container(
                                        height: MediaQuery.of(context).size.height*0.045,
                                        width: MediaQuery.of(context).size.height*0.045,
                                        decoration: new BoxDecoration(
                                          color: Colors.purpleAccent,
                                          borderRadius: new BorderRadius.circular(5.0),
                                        ),
                                        child: new Center(
                                          child: new Icon(Icons.lightbulb, color: Colors.white, size: 20.0),
                                        ),
                                      ),
                                      title: new Text('Projects in progress', style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                      trailing: new Text(
                                        snapshot.data.documents.length.toString(),
                                        style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  new Padding(
                                    padding: EdgeInsets.only(left: 80.0),
                                  child: new Divider(height: 2.0,color: Colors.grey[800])),
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.07,
                                    width: MediaQuery.of(context).size.width*0.90,
                                    color: Colors.transparent,
                                    // FILE LISTILE //
                                    child: new ListTile(
                                      onTap: () {
                                        //Navigator.push(context, new CupertinoPageRoute(builder: (context) => new FileSharedPage()));
                                      },
                                      leading: new Container(
                                        height: MediaQuery.of(context).size.height*0.045,
                                        width: MediaQuery.of(context).size.height*0.045,
                                        decoration: new BoxDecoration(
                                          color: Colors.purpleAccent[700],
                                          borderRadius: new BorderRadius.circular(5.0),
                                        ),
                                        child: new Center(
                                          child: new Icon(Icons.file_copy_rounded, color: Colors.white, size: 20.0),
                                        ),
                                      ),
                                      title: new Text('Files shared', style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                                    // FILE LISTILE //
                                    child: new ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context, 
                                          new CupertinoPageRoute(builder: (context) => new ProjectSettingsPage(
  
                                        )));
                                      },
                                      leading: new Container(
                                        height: MediaQuery.of(context).size.height*0.045,
                                        width: MediaQuery.of(context).size.height*0.045,
                                        decoration: new BoxDecoration(
                                          color: Colors.deepPurpleAccent,
                                          borderRadius: new BorderRadius.circular(5.0),
                                        ),
                                        child: new Center(
                                          child: new Icon(Icons.settings, color: Colors.white, size: 20.0),
                                        ),
                                      ),
                                      title: new Text('Settings', style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                      trailing: new Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                                    )
                                  ),*/
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