import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ProjectSettingsPage extends StatefulWidget {

  String currentUser;
  String currentUserPhoto;
  String currentUserUsername;
  String projectContext;
  String projectUID;
  String projectStyle;
  String timestampProject;
  bool projectIsPublished;


  ProjectSettingsPage({
    Key key,
    this.currentUser,
    this.currentUserPhoto,
    this.currentUserUsername,
    this.projectContext,
    this.projectIsPublished,
    this.timestampProject,
    this.projectUID,
    this.projectStyle,
    }) : super(key: key);


  @override
  ProjectSettingsPageState createState() => ProjectSettingsPageState();
}

class ProjectSettingsPageState extends State<ProjectSettingsPage> {

  final removeFromPublication = new SnackBar(
    backgroundColor: Colors.deepPurpleAccent,
    content: new Text('This project is now private.',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
    ),
    );

  final putInPublication = new SnackBar(
    backgroundColor: Colors.deepPurpleAccent,
    content: new Text('This project is now public.',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
    ),
    );


  TextEditingController _projectContextTextController = new TextEditingController();
  ScrollController _listMusicController = new ScrollController();

  String _fileMusicURL;
  int tabTracksSelected = 0;
  int selectedStyleInt;
  int _fileMusicDuration;
  String _fileCoverImage;
  bool _publishingInProgress = false;


  @override
  void initState() {
    _projectContextTextController = new TextEditingController(text: widget.projectContext);
    _listMusicController = new ScrollController();
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
              largeTitle: new Text('Settings',
                  style: new TextStyle(color: Colors.white),
                  ),
              trailing: new Material(
                color: Colors.transparent,
                child: new CupertinoSwitch(
                  activeColor: Colors.deepPurpleAccent,
                  value: widget.projectIsPublished,
                  onChanged: (bool value) {
                    setState(() {
                      widget.projectIsPublished = value;
                      });
                    if(value == false) {
                      Scaffold.of(context).showSnackBar(removeFromPublication);
                    } else if(value == true) {
                      Scaffold.of(context).showSnackBar(putInPublication);
                    }
      
                    },
                  ),
                ),
            ),
          ];
        }, 
        body: new Container(
          child: new SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                new Container(
                  child: new Text('Modify, remove from publication or delete.',
                  style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w500),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.06,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                new Container(
                  child: new Center(
                    child: new Text('Modify context',
                    style: new TextStyle(color: Colors.grey[300], fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.02,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  child: new Center(
                    child: new Text("Explain what you need to create this new track.",
                    style: new TextStyle(color: Colors.grey[700], fontSize: 11.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.02,
                  width: MediaQuery.of(context).size.width,
                ),
                //TextField
                new Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[900].withOpacity(0.5),
                  child: new Center(
                    child: new CupertinoTextField(
                      textAlign: TextAlign.justify,
                      padding: EdgeInsets.all(10.0),
                      maxLength: 170,
                      style: new TextStyle(color: Colors.white, fontSize: 18.0),
                      keyboardType: TextInputType.text,
                      scrollPhysics: new ScrollPhysics(),
                      keyboardAppearance: Brightness.dark,
                      placeholder: 'Aa',
                      placeholderStyle: new TextStyle(color: Colors.grey, fontSize: 15.0),
                      minLines: 5,
                      maxLines: 5,
                      controller: _projectContextTextController,
                      decoration: new BoxDecoration(
                      ),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.01,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      new Container(
                        child: new Text('170 max',
                        style: new TextStyle(color: Colors.grey, fontSize: 11.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      new Container(
                        height: MediaQuery.of(context).size.height*0.01,
                        width: MediaQuery.of(context).size.width*0.04,
                      ),
                    ],
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.05,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  child: new Center(
                    child: new Text('Modify the demo',
                    style: new TextStyle(color: Colors.grey[300], fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.02,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  child: new Center(
                    child: new Text("If you don't have a demo, choose a similar track.",
                    style: new TextStyle(color: Colors.grey[700], fontSize: 11.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.02,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  height: MediaQuery.of(context).size.height*0.30,
                  color: Colors.transparent,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    new Container(
                      width: MediaQuery.of(context).size.width*0.90,
                    child: new CupertinoSlidingSegmentedControl(
                      backgroundColor: Colors.grey[900],
                      children: <int, Widget>{
                        0: new Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        child: new Container(
                          child: new Text("Demo",
                          style: new TextStyle(color: tabTracksSelected == 0 ? Colors.white : Colors.grey, fontSize: 10.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                        ),
                        1: new Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          child: new Container(
                          child:  new Text("Unreleased",
                          style: new TextStyle(color: tabTracksSelected == 1 ? Colors.white : Colors.grey, fontSize: 10.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                        ),
                        2: new Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          child: new Container(
                          child:  new Text("Released",
                          style: new TextStyle(color: tabTracksSelected == 2 ? Colors.white : Colors.grey, fontSize: 10.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                        ),
                      },
                      groupValue: tabTracksSelected,
                      onValueChanged: (value) {
                        setState(() {
                        tabTracksSelected = value;
                        });
                    })),
                     new Container(
                      height: MediaQuery.of(context).size.height*0.20,
                      child: new FutureBuilder(
                        future: FirebaseFirestore.instance.collection('users').doc(widget.currentUser).collection(tabTracksSelected == 0 ? 'demoTracks' : tabTracksSelected == 1 ? 'unreleasedTracks' : 'releasedTracks').get(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting) {
                           return new Container(
                             color: Colors.transparent,
                             child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //new Center(child: new Text('Fetching tracks', style: new TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.bold))),
                                new Padding(
                                  padding: EdgeInsets.only(top: 0.0),
                                  child: new CupertinoActivityIndicator(
                                    animating: true,
                                    radius: 15.0,
                                    ),
                                  )]
                                ),
                              );
                          }
                          if(snapshot.hasError) {
                           return new Container(
                             color: Colors.grey[900].withOpacity(0.5),
                             child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Center(child: new Text('Check your network connection.', style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold))),
                                new Padding(
                                  padding: EdgeInsets.only(top: 30.0),
                                child: new Icon(Icons.network_check_outlined, color: Colors.grey, size: 40.0),
                                ),
                                  ],
                                ),
                              );
                          }
                          if(!snapshot.hasData) {
                           return new Container(
                             color: Colors.grey[900].withOpacity(0.5),
                             child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                new Center(child: new Text('No track here.', style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold))),
                                new Center(child: new Text('Upload a track to storage tab', style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold))),
                                new Center(child: new Text('before find it here.', style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              );
                          }
                          if(snapshot.data.documents.isEmpty){
                           return new Container(
                             color: Colors.grey[900].withOpacity(0.5),
                             child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                new Center(child: new Text('No track here.', style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold))),
                                new Center(child: new Text('Upload a track to storage tab', style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold))),
                                new Center(child: new Text('before find it here.', style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              );
                          }
                      return new ListView.builder(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        controller: _listMusicController,
                        scrollDirection: Axis.horizontal,
                        physics: new ScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot ds = snapshot.data.documents[index];
                          return StatefulBuilder(
                            builder: (BuildContext context, setListViewState) {
                            return new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              new Container(
                                height: MediaQuery.of(context).size.height*0.20,
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                     new InkWell(
                                       onTap: () {
                                         setState(() {
                                           _fileMusicURL = ds.data()['fileMusicURL'];
                                           _fileMusicDuration = ds.data()['fileMusicDuration'];
                                           _fileCoverImage = ds.data()['CoverImage'];
                                         });
                                       },
                                     child: new Container(
                                      height: MediaQuery.of(context).size.height*0.15,
                                      width: MediaQuery.of(context).size.height*0.15,
                                      decoration: new BoxDecoration(
                                        color: Colors.grey[900].withOpacity(0.7),
                                        borderRadius: new BorderRadius.circular(5.0),
                                      ),
                                      child: new Stack(
                                        children: [
                                          new Positioned(
                                            top: 0.0,
                                            left: 0.0,
                                            right: 0.0,
                                            bottom: 0.0,
                                            child: new ClipRRect(
                                        borderRadius: new BorderRadius.circular(5.0),
                                        child: ds.data()['coverImage'] != null
                                        ? new Image.network(ds.data()['coverImage'], fit: BoxFit.cover)
                                        : new Container(),
                                           ),
                                          ),
                                          _fileMusicURL == ds.data()['fileMusicURL']
                                          ? new Positioned(
                                            top: 0.0,
                                            left: 0.0,
                                            right: 0.0,
                                            bottom: 0.0,
                                            child: new Container(
                                              height: MediaQuery.of(context).size.height*0.15,
                                              width: MediaQuery.of(context).size.height*0.15,
                                              decoration: new BoxDecoration(
                                                color: Colors.grey[900].withOpacity(0.7),
                                                borderRadius: new BorderRadius.circular(5.0),
                                              ),
                                              child: new Center(
                                                child: new Icon(Icons.check, color: Colors.white, size: 40.0),
                                              ),
                                            ),
                                            )
                                            : new Container(),
                                        ],
                                      ),
                                      ),
                                     ),
                                          new Container(
                                            child: new Text(
                                              ds.data()['title'] != null
                                              ? ds.data()['title'].toString()
                                              : '',
                                            style: new TextStyle(color: Colors.grey[700],fontSize: 10.0, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          ],
                                      ),
                                    ),
                                    //Divider
                                    new Container(
                                      height: MediaQuery.of(context).size.height*0.02,
                                      width: MediaQuery.of(context).size.width*0.04,
                                    ),
                            ],
                          );
                            }
                          );
                        }
                      );
                        }
                        ),
                    ),
                    ],
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.05,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  child: new Center(
                    child: new Text('Modify a style',
                    style: new TextStyle(color: Colors.grey[300], fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.02,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  child: new Center(
                    child: new Text("Which style is this track.",
                    style: new TextStyle(color: Colors.grey[700], fontSize: 11.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.03,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  height: MediaQuery.of(context).size.height*0.10,
                  decoration: new BoxDecoration(
                    color: Colors.grey[900].withOpacity(0.5),
                    //borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: new Padding(
                    padding: EdgeInsets.all(0.0),
                  child: new CupertinoPicker(
                    backgroundColor: Colors.transparent,
                    itemExtent: 50.0, 
                    onSelectedItemChanged: (value) {
                      setState(() {
                        selectedStyleInt = value;
                      });
                    }, 
                    children: [
                      new Center(
                      child: new Text('Future-House',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Progressive-House',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Deep-House',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Acid-House',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Chill-House',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Trap',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Dubstep',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Dirty-Dutch',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Techno',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Trance',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                      new Center(
                      child: new Text('Hardstyle',
                      style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      )),
                    ],
                    ),
                  ),
                  ),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.08,
                  width: MediaQuery.of(context).size.width,
                ),
                new Container(
                  width: MediaQuery.of(context).size.width*0.70,
                child: _publishingInProgress == false
                 ? new CupertinoButton(
                  onPressed: () {
                    if(_projectContextTextController.value.text.length > 5 
                    && _fileMusicURL != null
                    && tabTracksSelected != null) {
                      setState(() {
                        _publishingInProgress = true;
                      });
                      String _timestampUpload = DateTime.now().microsecondsSinceEpoch.toString();
                      FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.currentUser)
                        .collection('projects')
                        .doc(_timestampUpload+widget.currentUser)
                        .set({
                          'context': _projectContextTextController.value.text.toString(),
                          'artistUID': widget.currentUser,
                          'timestamp': _timestampUpload,
                          'fileMusicURL': _fileMusicURL,
                          'coverImage' : _fileCoverImage,
                          'fileMusicDuration': _fileMusicDuration,
                          'style': 
                          selectedStyleInt == 0 ? 'futureHouse' 
                          : selectedStyleInt == 1 ? 'progressiveHouse' 
                          : selectedStyleInt == 2 ? 'deepHouse' 
                          : selectedStyleInt == 3 ? 'acidHouse'
                          : selectedStyleInt == 4 ? 'chillHouse'
                          : selectedStyleInt == 5 ? 'trap'
                          : selectedStyleInt == 6 ? 'dubstep'
                          : selectedStyleInt == 7 ? 'dirtyDutch'
                          : selectedStyleInt == 8 ? 'techno'
                          : selectedStyleInt == 9 ? 'trance'
                          : selectedStyleInt == 10 ? 'hardstyle'
                          : 'futureHouse',
                        }).whenComplete(() {
                          print('Cloud Firestore : Added to projets area CurrentUser');
                          FirebaseFirestore.instance
                            .collection(
                          selectedStyleInt == 0 ? 'ProjectfutureHouse' 
                          : selectedStyleInt == 1 ? 'ProjectprogressiveHouse' 
                          : selectedStyleInt == 2 ? 'ProjectdeepHouse' 
                          : selectedStyleInt == 3 ? 'ProjectacidHouse'
                          : selectedStyleInt == 4 ? 'ProjectchillHouse'
                          : selectedStyleInt == 5 ? 'Projecttrap'
                          : selectedStyleInt == 6 ? 'Projectdubstep'
                          : selectedStyleInt == 7 ? 'ProjectdirtyDutch'
                          : selectedStyleInt == 8 ? 'Projecttechno'
                          : selectedStyleInt == 9 ? 'Projecttrance'
                          : selectedStyleInt == 10 ? 'Projecthardstyle'
                          : 'ProjectfutureHouse',
                          ).doc(_timestampUpload+widget.currentUser)
                          .set({
                          'context': _projectContextTextController.value.text.toString(),
                          'artistUID': widget.currentUser,
                          'timestamp': _timestampUpload,
                          'fileMusicURL': _fileMusicURL,
                          'coverImage' : _fileCoverImage,
                          'fileMusicDuration': _fileMusicDuration,
                          'style': 
                          selectedStyleInt == 0 ? 'futureHouse' 
                          : selectedStyleInt == 1 ? 'progressiveHouse' 
                          : selectedStyleInt == 2 ? 'deepHouse' 
                          : selectedStyleInt == 3 ? 'acidHouse'
                          : selectedStyleInt == 4 ? 'chillHouse'
                          : selectedStyleInt == 5 ? 'trap'
                          : selectedStyleInt == 6 ? 'dubstep'
                          : selectedStyleInt == 7 ? 'dirtyDutch'
                          : selectedStyleInt == 8 ? 'techno'
                          : selectedStyleInt == 9 ? 'trance'
                          : selectedStyleInt == 10 ? 'hardstyle'
                          : 'futureHouse',
                          }).whenComplete(() {
                            print('Cloud Firestore : Added to discover project tab');
                            _projectContextTextController.clear();
                            setState(() {
                              _publishingInProgress = false;
                            });
                            Navigator.pop(context);
                          });
                        });
                    }
                  },
                  color: 
                  _projectContextTextController.value.text.length > 5 
                    && _fileMusicURL != null
                    && tabTracksSelected != null
                    ? Colors.purpleAccent
                    : Colors.purpleAccent.withOpacity(0.2),
                    child: new Center(
                    child: new Text('PUBLISH',
                    style: new TextStyle(
                      color:
                      _projectContextTextController.value.text.length > 5 
                    && _fileMusicURL != null
                    && tabTracksSelected != null
                    ? Colors.white
                    : Colors.grey,
                      ),
                    ),
                  ),
                  )
                  : new Container(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new CupertinoActivityIndicator(
                          radius: 8.0,
                          animating: true,
                        ),
                        new Text('Publication in progress',
                        style: new TextStyle(color: Colors.purpleAccent, fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        new CupertinoActivityIndicator(
                          radius: 8.0,
                          animating: true,
                        ),
                      ],
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }




  modifyStateToPrivate() {
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .collection('projects')
      .doc(widget.projectUID)
      .update({
        'published': false,
      }).whenComplete(() {
      FirebaseFirestore.instance
        .collection(widget.projectStyle)
        .doc(widget.projectUID)
        .delete().whenComplete(() {
          print('Cloud Firestore : Project now is private');
        });
      });
  }
}