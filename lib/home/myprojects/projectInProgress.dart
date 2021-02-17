import 'dart:ui';
import 'package:SONOZ/Discover/projectPublication.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ProjectInProgressPage extends StatefulWidget {

  String currentUser;
  String currentUserPhoto;
  String currentUserUsername;
  int lengthOfSnapshot;
  AsyncSnapshot<dynamic> snapshotFromHome;


  ProjectInProgressPage({
    Key key, 
    this.currentUser,
    this.currentUserPhoto,
    this.currentUserUsername,
    this.lengthOfSnapshot,
    this.snapshotFromHome,
    }) : super(key: key);


  @override
  ProjectInProgressPageState createState() => ProjectInProgressPageState();
}

class ProjectInProgressPageState extends State<ProjectInProgressPage> {


  ScrollController _contributorsListViewController = new ScrollController();


  @override
  void initState() {
    audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
    super.initState();
  }

  String _trackChoosenToListen;
  bool _audioIsInitializing = false;
  bool _audioLaunched = false;
  AudioPlayer audioPlayer;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
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
              actionsForegroundColor: Colors.purpleAccent,
              previousPageTitle: 'Home',
              automaticallyImplyTitle: true,
              automaticallyImplyLeading: true,
              transitionBetweenRoutes: true,
              backgroundColor: Colors.black.withOpacity(0.7),
              largeTitle: new Text('In progress',
                  style: new TextStyle(color: Colors.white),
                  ),
              trailing: new Material(
                color: Colors.transparent, 
                child: new IconButton(
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                icon: new Icon(Icons.add_circle_outline_rounded, color: Colors.purpleAccent, size: 25.0),
                onPressed: () {
                  Navigator.push(context, new CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => new ProjectPublicationPage(
                      currentUser: widget.currentUser,
                      currentUserPhoto: widget.currentUserPhoto,
                      currentUserUsername: widget.currentUserUsername,
                    )));
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
                color: Colors.transparent,
              ),
              new Container(
                child: new Text(
                'Here, manage all your current projects.',
                style: new TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w500),
                ),
              ),
              //Divider
              new Container(
                height: MediaQuery.of(context).size.height*0.02,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                child: widget.lengthOfSnapshot > 0
                ? new ListView.builder(
                  shrinkWrap: true,
                  physics: new NeverScrollableScrollPhysics(),
                  controller: _contributorsListViewController,
                  scrollDirection: Axis.vertical,
                  itemCount: widget.lengthOfSnapshot,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot ds = widget.snapshotFromHome.data.documents[index];
                    return new Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: new Container(
                    height: MediaQuery.of(context).size.height*0.45,
                    width: MediaQuery.of(context).size.width*0.80,
                    constraints: new BoxConstraints(
                      minHeight: 400.0,
                      minWidth: 300.0,
                    ),
                    decoration: new BoxDecoration(
                      color: Colors.grey[900].withOpacity(0.5),
                      border: new Border.all(
                        width: 1.0,
                        color: _audioLaunched == false ? Colors.grey[900] : Colors.purpleAccent,
                      ),
                      borderRadius: new BorderRadius.circular(5.0),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Container(
                          height: MediaQuery.of(context).size.height*0.07,
                          color: Colors.transparent,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //Divider
                              new Container(
                                height: MediaQuery.of(context).size.height*0.07,
                                width: MediaQuery.of(context).size.width*0.03,
                              ),
                              new Container(
                                height: MediaQuery.of(context).size.height*0.05,
                                width: MediaQuery.of(context).size.height*0.05,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[800],
                                ),
                                child: new ClipOval(
                                  child: ds.data()['artistProfilePhoto'] != null
                                  ? new Image.network(ds.data()['artistProfilePhoto'], fit: BoxFit.cover)
                                  : new Container(),
                                ),
                              ),
                              //Divider
                              new Container(
                                height: MediaQuery.of(context).size.height*0.07,
                                width: MediaQuery.of(context).size.width*0.03,
                              ),
                              new Container(
                                child: new Text(ds.data()['artistUsername'] != null
                                ? ds.data()['artistUsername']
                                : '',
                                style: new TextStyle(color: Colors.grey, fontSize: 15.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.13,
                          width: MediaQuery.of(context).size.width*0.80,
                          color: Colors.transparent,
                          child: new Center(
                          child: new Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: new Text(ds.data()['context'] != null
                          ? ds.data()['context']
                          : '',
                          style: new TextStyle(color: Colors.white),
                          textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.10,
                          width: MediaQuery.of(context).size.width*0.80,
                          color: Colors.transparent,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new InkWell(
                              child: new Container(
                                height: MediaQuery.of(context).size.height*0.09,
                                width: MediaQuery.of(context).size.height*0.09,
                                decoration: new BoxDecoration(
                                  color: Colors.grey[900].withOpacity(0.8),
                                  shape: BoxShape.circle,
                                  border: new Border.all(
                                    width: 2.0,
                                    color: Colors.purpleAccent,
                                  ),
                                ),
                                  child: _trackChoosenToListen == ds.data()['fileMusicURL'] && _audioIsInitializing == true
                                  ? new CupertinoActivityIndicator(radius: 6.0, animating: true)
                                  //
                                  : _trackChoosenToListen == ds.data()['fileMusicURL'] && _audioIsInitializing == false && _audioLaunched == true
                                  ? new IconButton(
                                    onPressed: (){
                                      audioPlayer.stop().whenComplete(() {
                                        setState(() {
                                          _audioIsInitializing = false;
                                          _audioLaunched = false;
                                          _trackChoosenToListen = '';
                                        });
                                        print(('AudioPlayer : Stop'));
                                      });
                                    },
                                  icon: new Icon(Icons.stop, color: Colors.white, size: 40.0))
                                  : new IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _trackChoosenToListen = ds.data()['fileMusicURL'];
                                        _audioIsInitializing = true;
                                      });
                                      AudioPlayer.logEnabled = true;
                                        audioPlayer.play(ds.data()['fileMusicURL'], volume: 1.0).whenComplete(() {
                                          setState(() {
                                            _audioIsInitializing = false;
                                            _audioLaunched = true;
                                          });
                                          print(('AudioPlayer : Play'));
                                        });
                                    },
                                  icon: new Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40.0))
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.08,
                          width: MediaQuery.of(context).size.width*0.80,
                          color: Colors.transparent,
                          child: new Center(
                            child: new Container(
                              height: MediaQuery.of(context).size.height*0.05,
                              width: MediaQuery.of(context).size.width*0.50,
                              decoration: new BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: new BorderRadius.circular(5.0),
                                border: new Border.all(
                                  width: 1.0,
                                  color: Colors.grey,
                                ),
                              ),
                            child: ds.data()['adminUID'] == widget.currentUser
                            ? new InkWell(
                              onTap: () {
                                showDialog(
                                context: context,
                                builder: (BuildContext context) => 
                                new CupertinoAlertDialog(
                                  title: new Text("Delete this project ?",
                                  style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                  content: new Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: new Text("No more new producers will not find it. You keep your group conversion about it.",
                                    style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal),
                                  )),
                                  actions: <Widget>[
                                    new CupertinoDialogAction(
                                      child: new Text("Delete", style: new TextStyle(color: Colors.red, fontSize: 13.0, fontWeight: FontWeight.normal)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        deleteProject(ds.data()['documentUID'], ds.data()['style']);
                                        Navigator.pop(context);
                                        },
                                    ),
                                    new CupertinoDialogAction(
                                      child: Text("No, thanks", style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal)),
                                      onPressed: () {Navigator.pop(context);},
                                    )
                                  ],
                                )
                                );
                               },
                              child: new Container(
                                child: new Center(
                                child: new Text('Delete',
                                style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                                ),
                                ),
                              ),
                            )
                            : new InkWell(
                              onTap: () {
                               },
                              child: new Container(
                                child: new Center(
                                child: new Text('Quit',
                                style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                                ),
                                ),
                              ),
                            )
                          ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  );
                })
                : new Center(
                  child: new Container(
                    height: MediaQuery.of(context).size.height*0.50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: new Center(
                      child: new Container(
                        height: MediaQuery.of(context).size.height*0.30,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.transparent,
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            new Text('No project yet.',
                            style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            new IconButton(
                              alignment: Alignment.center,
                              icon: new Icon(Icons.add_box_rounded, size: 50.0, color: Colors.white),
                              onPressed: () {},
                           ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  deleteProject(String projectUID, String musicStyle) {
    FirebaseFirestore.instance
      .collection('users')
      .doc(widget.currentUser)
      .collection('projects')
      .doc(projectUID)
      .delete().whenComplete(() {
        print('Cloud Firestore : Remove from my projects.');
        FirebaseFirestore.instance
          .collection('Project$musicStyle')
          .doc(projectUID)
          .delete().whenComplete(() {
            print('Cloud Firestore : Remove from projects collection.');
          });
      });
  }
}
                    