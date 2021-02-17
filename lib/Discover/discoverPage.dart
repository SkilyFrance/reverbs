import 'package:SONOZ/Discover/projectPublication.dart';
import 'package:SONOZ/DiscoverTab/discoverTab.dart';
import 'package:SONOZ/homeOld/styleMusicTab.dart';
import 'package:SONOZ/homeOld/uploadMusic.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../DiscoverTab/profileDetails.dart';
import '../profileOld.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../services/slideRoute.dart';
import 'exampleProject.dart';

class DiscoverPage extends StatefulWidget {

  String currentUser; 
  String currentUserType;
  String currentUserUsername;
  String currentUserPhoto;

  DiscoverPage({Key key, this.currentUser, this.currentUserType, this.currentUserUsername, this.currentUserPhoto}) : super(key: key);




  @override
  DiscoverPageState createState() => DiscoverPageState();
}

class DiscoverPageState extends State<DiscoverPage> with SingleTickerProviderStateMixin {

  final submissionSnackBar = new SnackBar(
    backgroundColor: Colors.deepPurpleAccent,
    content: new Text('Submission sent to this project 🚀',
    textAlign: TextAlign.center,
    style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
    ),
    );


  int sharedValue = 0;
  String _trackChoosenToListen = '';


final Map<int, Widget> segmentTextWidgets = <int, Widget>{
    0: new Padding(
      padding: EdgeInsets.all(10.0),
    child: new Container(
      child: new Text("Projets"),
    ),
    ),
    1: new Padding(
      padding: EdgeInsets.all(10.0),
      child: new Container(
      child:  new Text("Musics"),
    ),
    ),
  };

  TabController _tabController;
  PageController _pageController;
  ScrollController _scrollViewController;
  ScrollController _djListViewController;
  TextEditingController _searchTextEditingController = new TextEditingController();
  String artistQueryName;
  var top = 0.0;
  
  //
  bool inSearching = false;

  //Filter for Home //
  bool filterRecentIsChoosen = true;
  bool filterTrendIsChoosen = false;
  //ListView flatButton//
  bool edmChoosen = true;
  bool electroChoosen = false;
  bool houseChoosen = false;
  bool acidHouseChoosen = false;
  bool futureHouseChoosen = false;
  bool deepHouseChoosen = false;
  bool chillHouseChoosen = false;
  bool technoChoosen = false;
  bool tranceChoosen = false;
  bool progressiveChoosen = false;
  bool minimaleChoosen = false;
  bool dubstepChoosen = false;
  bool trapChoosen = false;
  bool dirtyDutchChoosen = false;
  bool moombathtonChoosen = false;
  bool hardstyleChoosen = false;

  var songsList = new List<int>.generate(50, (i) => i + 1);
  ScrollController songsGriViewController = new ScrollController(initialScrollOffset: 0.0);
  ScrollController _songStyleController = new ScrollController(initialScrollOffset: 0.0);
  ScrollController _artistListTracks = new ScrollController();


  //AudioPlayer variables
  AudioPlayer audioPlayer;
  int audioPlayerControllerPosition;
  int audioPlayerControllerDuration;
  bool _musicIsInitializing = false;
  bool _audioLaunched = false;
  bool _audioIsOnPause = false;
  //Variables for mediaPlayer reduced
  String currentArtistPlayedUsername;
  String currentTitlePlayed;
  String currentCoverImagePlayed;
  String currenProfilePhotoArtistPlayed;
  String currentArtistUIDPlayed;



  @override
  void initState() {
    print(widget.currentUserType);
    audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
    _tabController = new TabController(length: 6, vsync: this);
    _scrollViewController = new ScrollController();
    _djListViewController = new ScrollController();
    _artistListTracks = new ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.stop();
    super.dispose();
  }






  // VIEW BY PROJECT ///////////////////////////////////////////////////////////////
  ScrollController _futureHouseListViewController = new ScrollController();
  ScrollController _progressiveHouseListViewController = new ScrollController();
  ScrollController _deepHouseListViewController = new ScrollController();
  ScrollController _acidHouseListViewController = new ScrollController();
  ScrollController _chillHouseListViewController = new ScrollController();
  ScrollController _trapListViewController = new ScrollController();
  ScrollController _dubstepListViewController = new ScrollController();
  ScrollController _dirtyDutchListViewController = new ScrollController();
  ScrollController _technoListViewController = new ScrollController();
  ScrollController _tranceListViewController = new ScrollController();
  ScrollController _hardstyleListViewController = new ScrollController();

  viewProjectWidget(String projectMusicStyle ,String musicStyle, int snapshotLength, AsyncSnapshot<dynamic> snapshotCurrent, ScrollController _controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
    new Container(
      height: MediaQuery.of(context).size.height*0.50,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Divider
          new Container(
            width: MediaQuery.of(context).size.width,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.01,
                  width: MediaQuery.of(context).size.width*0.05,
                ),
                new Text(musicStyle.toString(),
                style: new TextStyle(color: Colors.grey[700],fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          new Container(
            height: MediaQuery.of(context).size.height*0.45,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: new ListView.builder(
              padding: EdgeInsets.only(left: 10.0),
              scrollDirection: Axis.horizontal,
              controller: _controller,
              itemCount: snapshotCurrent.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot ds = snapshotCurrent.data.documents[index];
                return new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  new Container(
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
                              _trackChoosenToListen == ds.data()['fileMusicURL'] && _musicIsInitializing == false && _audioLaunched == true
                              ? new Container(
                                height: MediaQuery.of(context).size.height*0.09,
                                child: new Center(
                                  child: new Text('On play.',
                                  style: new TextStyle(color: Colors.purpleAccent, fontSize: 20.0, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                             : _trackChoosenToListen == ds.data()['fileMusicURL'] && _musicIsInitializing == true
                             ? new Container(
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
                                child: new Center(
                                  child: new CupertinoActivityIndicator(animating: true, radius: 7.0)
                                ),
                             )
                             : new InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                onTap: () {
                                  if(_audioLaunched == true) {
                                   setState(() {
                                     _trackChoosenToListen = ds.data()['fileMusicURL'];
                                     _musicIsInitializing = true;
                                     audioPlayerControllerPosition = 0;
                                     audioPlayerControllerDuration = ds.data()['fileMusicDuration'];
                                     currentArtistPlayedUsername = ds.data()['artistUsername'];
                                     currenProfilePhotoArtistPlayed = ds.data()['artistProfilePhoto'];
                                     currentArtistUIDPlayed = ds.data()['artistUID'];
                                     currentCoverImagePlayed = ds.data()['coverImage'];
                                     currentTitlePlayed = ds.data()['title'];
                                   });
                                   audioPlayer.play(ds.data()['fileMusicURL'], volume: 1.0).whenComplete((){
                                   });
                                  } else {
                                    //No audio launched
                                  setState(() {
                                    _trackChoosenToListen = ds.data()['fileMusicURL'];
                                    audioPlayerControllerDuration = ds.data()['fileMusicDuration'];
                                    currentArtistPlayedUsername = ds.data()['artistUsername'];
                                    currenProfilePhotoArtistPlayed = ds.data()['artistProfilePhoto'];
                                    currentArtistUIDPlayed = ds.data()['artistUID'];
                                    currentTitlePlayed = ds.data()['title'];
                                    currentCoverImagePlayed = ds.data()['coverImage'];
                                    _musicIsInitializing = true;
                                  });
                                  AudioPlayer.logEnabled = true;
                                  audioPlayer.play(ds.data()['fileMusicURL'], volume: 1.0).whenComplete(() {
                                    audioPlayer.onAudioPositionChanged.listen((event) {
                                      setState(() {
                                        audioPlayerControllerPosition = event.inMilliseconds;
                                      });
                                      if(event.inMilliseconds > 0 && event.inMilliseconds < 2000) {
                                        setState(() {
                                          _musicIsInitializing = false;
                                          _audioLaunched = true;
                                          print('ok iniatilized');
                                        });
                                      }
                                     });
                                  });
                                  }
                                },
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
                                child: new Center(
                                  child: _trackChoosenToListen == ds.data()['fileMusicURL']
                                  ? new CupertinoActivityIndicator(
                                    animating: true,
                                    radius: 7.0,
                                  )
                                  : new Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40.0)
                                ),
                              ),
                              )
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
                                  color: ds.data()['submissions']['${widget.currentUser}'] != null ? Colors.transparent : Colors.grey,
                                ),
                              ),
                            child: 
                            ds.data()['submissions'][widget.currentUser] != null
                            ? new Container(
                              child: new Center(
                                child: new Text(
                                  ds.data()['submissions'][widget.currentUser] == 'inWaiting'
                                  ? 'In waiting'
                                  : ds.data()['submissions'][widget.currentUser] == 'Accepted'
                                  ? 'Accepted'
                                  : 'Declined',
                                  style: new TextStyle(color: Colors.deepPurpleAccent, fontSize: 13.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                            : new InkWell(
                              onTap: () {
                                print(ds.data()['submissions'][widget.currentUser]);
                                submiToAProject(ds.data()['adminUID'], ds.data()['documentUID'], projectMusicStyle, ds.data()['submissions']);
                                Scaffold.of(context).showSnackBar(submissionSnackBar);
                               },
                              child: new Container(
                                child: new Center(
                                child: new Text('Submit',
                                style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                                ),
                                ),
                              ),
                            ),
                          ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.02,
                    width: MediaQuery.of(context).size.width*0.03,
                  ),
                  ],
                );
              }),
          ),
        ],
      ),
    ),
     //Divider
     new Container(
       height: MediaQuery.of(context).size.height*0.05,
       width: MediaQuery.of(context).size.width,
     ),
    ],
    );
  }
  // END ///////////////////////////////////////////////////////////////

  // VIEW BY MUSICS ///////////////////////////////////////////////////////////////

  ScrollController _futureHouseMusicListViewController = new ScrollController();
  ScrollController _progressiveHouseMusicListViewController = new ScrollController();
  ScrollController _deepHouseMusicListViewController = new ScrollController();
  ScrollController _acidHouseMusicListViewController = new ScrollController();
  ScrollController _chillHouseMusicListViewController = new ScrollController();
  ScrollController _trapMusicListViewController = new ScrollController();
  ScrollController _dubstepMusicListViewController = new ScrollController();
  ScrollController _dirtyDutchMusicListViewController = new ScrollController();
  ScrollController _technoMusicListViewController = new ScrollController();
  ScrollController _tranceMusicListViewController = new ScrollController();
  ScrollController _hardstyleMusicListViewController = new ScrollController();

  viewMusicWidget(String musicStyle, int snapshotLength, AsyncSnapshot<dynamic> snapshotCurrent, ScrollController _controller) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
    new Container(
      height: MediaQuery.of(context).size.height*0.30,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Divider
          new Container(
            width: MediaQuery.of(context).size.width,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.01,
                  width: MediaQuery.of(context).size.width*0.05,
                ),
                new Text(musicStyle,
                style: new TextStyle(color: Colors.grey[600],fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
              new Container(
                height: MediaQuery.of(context).size.height*0.25,
                color: Colors.transparent,
                child: new ListView.builder(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  physics: new ScrollPhysics(),
                  itemCount: snapshotLength,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot ds = snapshotCurrent.data.documents[index];
                    return new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        new Container(
                          height: MediaQuery.of(context).size.height*0.25,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new InkWell(
                                onTap: () {
                                },
                              child: new Container(
                                height: MediaQuery.of(context).size.height*0.18,
                                width: MediaQuery.of(context).size.height*0.18,
                                decoration: new BoxDecoration(
                                  color: Colors.grey[900].withOpacity(0.7),
                                  borderRadius: new BorderRadius.circular(5.0),
                                  border: new Border.all(
                                    width: 2.0,
                                    color: _trackChoosenToListen == ds.data()['fileMusicURL'] ? Colors.purpleAccent : Colors.transparent,
                                  ),
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
                                    new Positioned(
                                      top: 0.0,
                                      left: 0.0,
                                      right: 0.0,
                                      bottom: 0.0,
                                      child: new Container(
                                        child: new Center(
                                          child: new InkWell(
                                            onTap: () {
  
                                            },
                                          child: 
                                          _trackChoosenToListen == ds.data()['fileMusicURL'] && _audioIsOnPause == true
                                          ? new Container(
                                            decoration: new BoxDecoration(
                                              color: Colors.white.withOpacity(0.3),
                                              shape: BoxShape.circle,
                                            ),
                                            child: new Padding(
                                              padding: EdgeInsets.all(7.0),
                                              child: new IconButton(
                                                icon: new Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30.0), 
                                                onPressed: () {
                                                  setState(() {
                                                    audioPlayer.resume();
                                                    _audioIsOnPause = false;
                                                  });
                                                },
                                                ),
                                            ))
                                          : _trackChoosenToListen == ds.data()['fileMusicURL'] && _audioIsOnPause == false
                                          ? new Container(
                                           decoration: new BoxDecoration(
                                             color: Colors.white.withOpacity(0.3),
                                             shape: BoxShape.circle,
                                           ),
                                           child: new Padding(
                                             padding: EdgeInsets.all(7.0),
                                             child: new IconButton(
                                               icon: new Icon(Icons.pause, color: Colors.white, size: 30.0), 
                                               onPressed: () {
                                                 setState(() {
                                                   audioPlayer.pause();
                                                   _audioIsOnPause = true;
                                                 });
                                               },
                                               ),
                                           ),
                                         )
                                         : new Container(
                                            decoration: new BoxDecoration(
                                              color: Colors.white.withOpacity(0.3),
                                              shape: BoxShape.circle,
                                            ),
                                            child: new Padding(
                                              padding: EdgeInsets.all(7.0),
                                              child: new IconButton(
                                                icon: new Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30.0), 
                                                onPressed: () {
                                                  if(_audioLaunched == true) {
                                                   setState(() {
                                                     _trackChoosenToListen = ds.data()['fileMusicURL'];
                                                     audioPlayerControllerPosition = 0;
                                                     audioPlayerControllerDuration = ds.data()['fileMusicDuration'];
                                                     currentArtistPlayedUsername = ds.data()['artistUsername'];
                                                     currenProfilePhotoArtistPlayed = ds.data()['artistProfilePhoto'];
                                                     currentArtistUIDPlayed = ds.data()['artistUID'];
                                                     currentCoverImagePlayed = ds.data()['coverImage'];
                                                     currentTitlePlayed = ds.data()['title'];
                                                   });
                                                   audioPlayer.play(ds.data()['fileMusicURL'], volume: 1.0);
                                                  } else {
                                                    //No audio launched yet
                                                    setState(() {
                                                      _trackChoosenToListen = ds.data()['fileMusicURL'];
                                                      audioPlayerControllerDuration = ds.data()['fileMusicDuration'];
                                                      currentArtistPlayedUsername = ds.data()['artistUsername'];
                                                      currenProfilePhotoArtistPlayed = ds.data()['artistProfilePhoto'];
                                                      currentArtistUIDPlayed = ds.data()['artistUID'];
                                                      currentTitlePlayed = ds.data()['title'];
                                                      currentCoverImagePlayed = ds.data()['coverImage'];
                                                      _musicIsInitializing = true;
                                                    });
                                                    AudioPlayer.logEnabled = true;
                                                    audioPlayer.play(ds.data()['fileMusicURL'], volume: 1.0).whenComplete(() {
                                                      audioPlayer.onAudioPositionChanged.listen((event) {
                                                        setState(() {
                                                          audioPlayerControllerPosition = event.inMilliseconds;
                                                        });
                                                        if(event.inMilliseconds > 0 && event.inMilliseconds < 2000) {
                                                          setState(() {
                                                            _musicIsInitializing = false;
                                                            _audioLaunched = true;
                                                            print('ok iniatilized');
                                                          });
                                                        }
                                                      });
                                                    });
                                                  }
                                                },
                                                ),
                                            ))
                                        ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ),
                              ),
                              new Container(
                                child: new Text(ds.data()['artistUsername'] != null
                                ? ds.data()['artistUsername']
                                : '',
                                style: new TextStyle(color: Colors.white,fontSize: 12.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                              new Container(
                                child: new Text(ds.data()['title'] != null
                                ? ds.data()['title']
                                : '',
                                style: new TextStyle(color: Colors.grey,fontSize: 10.0, fontWeight: FontWeight.w500),
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
      ],
    );
  }

  // END ///////////////////////////////////////////////////////////////






  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget> [
            new CupertinoSliverNavigationBar(
              transitionBetweenRoutes: false,
              backgroundColor: Colors.black.withOpacity(0.7),
              largeTitle: new Text('Discover',
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
          child: new Stack(
            children: [
              new Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: new Container(
                  child: new SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 170.0),
                    child: new Container(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        //Divider
                        new Container(
                          height: MediaQuery.of(context).size.height*0.03,
                          width: MediaQuery.of(context).size.width,
                        ),
                new CupertinoSlidingSegmentedControl(
                  backgroundColor: Colors.grey[900],
                  children: <int, Widget>{
                    0: new Padding(
                      padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                    child: new Container(
                      child: new Text("Projects",
                      style: new TextStyle(color: sharedValue == 0 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                      ),
                    ),
                    ),
                    1: new Padding(
                      padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                      child: new Container(
                      child:  new Text("Musics",
                      style: new TextStyle(color: sharedValue == 1 ? Colors.white : Colors.grey, fontSize: 14.0, fontWeight: FontWeight.w700),
                      ),
                    ),
                    ),
                  },
                  groupValue: sharedValue,
                  onValueChanged: (value) {
                    setState(() {
                    sharedValue = value;
                    });
                }),
                //Divider
                new Container(
                  height: MediaQuery.of(context).size.height*0.05,
                  width: MediaQuery.of(context).size.width,
                ),
                sharedValue == 0
                ? new Container(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //FutureHouse
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('ProjectfutureHouse').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container(child: new ExampleProjectPage(musicStyle: 'ProjectfutureHouse'));}
                          if(snapshot.data.documents.isEmpty) { return new Container(child: new ExampleProjectPage(musicStyle: 'ProjectfutureHouse'));}
                          return viewProjectWidget('ProjectfutureHouse', 'Future-house',snapshot.data.documents.length, snapshot, _futureHouseListViewController);
                        }),
                        //ProgressiveHouse
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('ProjectprogressiveHouse').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewProjectWidget('ProjectprogressiveHouse','Progressive-house',snapshot.data.documents.length, snapshot, _progressiveHouseListViewController);
                        }),
                        //DeepHouse
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('ProjectdeepHouse').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewProjectWidget('ProjectdeepHouse','Deep-house',snapshot.data.documents.length, snapshot, _deepHouseListViewController);
                        }),
                        //AcidHouse
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('ProjectacidHouse').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewProjectWidget('ProjectacidHouse','Acid-house',snapshot.data.documents.length, snapshot, _acidHouseListViewController);
                        }),
                        //ChillHouse
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('ProjectchillHouse').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewProjectWidget('ProjectchillHouse','Chill-house',snapshot.data.documents.length, snapshot, _chillHouseListViewController);
                        }),
                        //Trap
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('Projecttrap').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewProjectWidget('Projecttrap','Trap',snapshot.data.documents.length, snapshot, _trapListViewController);
                        }),
                        //Dubstep
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('Projectdubstep').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewProjectWidget('Projectdubstep','Dubstep',snapshot.data.documents.length, snapshot, _dubstepListViewController);
                        }),
                        //DirtyDutch
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('ProjectdirtyDutch').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewProjectWidget('ProjectdirtyDutch','Dirty-dutch',snapshot.data.documents.length, snapshot, _dirtyDutchListViewController);
                        }),
                        //Techno
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('Projecttechno').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewProjectWidget('Projecttechno','Techno',snapshot.data.documents.length, snapshot, _technoListViewController);
                        }),
                        //Trance
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('Projecttrance').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewProjectWidget('Projecttrance','Trance',snapshot.data.documents.length, snapshot, _tranceListViewController);
                        }),
                        //Hardstyle
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('Projecthardstyle').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewProjectWidget('Projecthardstyle','Hardstyle',snapshot.data.documents.length, snapshot, _hardstyleListViewController);
                        }),
                  ],
                  ),
                )
                //MusicsContainer
                : new Container(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //futureHouse
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('MusicfutureHouse').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewMusicWidget('Future-House',snapshot.data.documents.length, snapshot, _futureHouseMusicListViewController);
                        }),
                      //progressiveHouse
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('MusicprogressiveHouse').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewMusicWidget('Progressive-House',snapshot.data.documents.length, snapshot, _progressiveHouseMusicListViewController);
                        }),
                      //deepHouse
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('MusicdeepHouse').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewMusicWidget('Deep-House',snapshot.data.documents.length, snapshot, _deepHouseMusicListViewController);
                        }),
                      //acidHouse
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('MusicacidHouse').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewMusicWidget('Acid-House',snapshot.data.documents.length, snapshot, _acidHouseMusicListViewController);
                        }),
                      //chillHouse
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('MusicchillHouse').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewMusicWidget('Chill-House',snapshot.data.documents.length, snapshot, _chillHouseMusicListViewController);
                        }),
                      //Trap
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('Musictrap').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewMusicWidget('Trap',snapshot.data.documents.length, snapshot, _trapMusicListViewController);
                        }),
                      //dubstep
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('Musicdubstep').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewMusicWidget('Dubstep',snapshot.data.documents.length, snapshot, _dubstepMusicListViewController);
                        }),
                      //dirtyDutch
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('MusicdirtyDutch').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewMusicWidget('Dirty-dutch',snapshot.data.documents.length, snapshot, _dirtyDutchMusicListViewController);
                        }),
                      //techno
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('Musictechno').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewMusicWidget('Techno',snapshot.data.documents.length, snapshot, _technoMusicListViewController);
                        }),
                      //trance
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('Musictrance').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewMusicWidget('Trance',snapshot.data.documents.length, snapshot, _tranceMusicListViewController);
                        }),
                      //hardstyle
                      new StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('Musichardstyle').snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasError) { return new Container();}
                          if(!snapshot.hasData) { return new Container();}
                          if(snapshot.data.documents.isEmpty) { return new Container();}
                          return viewMusicWidget('Hardstyle',snapshot.data.documents.length, snapshot, _hardstyleMusicListViewController);
                        }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ),
        ),
        _audioLaunched == true
        ? new Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              new InkWell(
                onTap: () {
                  showBarModalBottomSheet(
                    context: context, 
                    builder: (context){
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter modalSetState) {
                         return new Container(
                         height: MediaQuery.of(context).size.height*0.55,
                         width: MediaQuery.of(context).size.width,
                         color: Color(0xFF181818),
                         child: new Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             new Container(
                               child: new Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                             new Container(
                               height: MediaQuery.of(context).size.height*0.03,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                             ),
                             new Container(
                               child: new Center(
                                 child: new Text(currentArtistPlayedUsername != null
                                 ? currentArtistPlayedUsername
                                 : 'Unknown',
                                 style: new TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16.0, fontWeight: FontWeight.bold),
                                 ),
                               ),
                             ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.03,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                              ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.06,
                               width: MediaQuery.of(context).size.height*0.06,
                               decoration: new BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: Colors.grey[900].withOpacity(0.5),
                               ),
                               child: new ClipOval(
                               child: currenProfilePhotoArtistPlayed != null
                               ? new Image.network(currenProfilePhotoArtistPlayed, fit: BoxFit.cover)
                               : new Container(),
                               ),
                              ),
                             new Container(
                               height: MediaQuery.of(context).size.height*0.03,
                               width: MediaQuery.of(context).size.width,
                               color: Colors.transparent,
                              ),
                              new Container(
                                height: MediaQuery.of(context).size.height*0.20,
                                //Future builder
                                child: new FutureBuilder(
                                  future: FirebaseFirestore.instance.collection('users').doc(currentArtistUIDPlayed).collection('releasedTracks').get(),
                                  builder: (BuildContext context, snapshot) {
                                    if(snapshot.connectionState == ConnectionState.waiting) {
                                    return new Container(
                                        height: MediaQuery.of(context).size.height*0.10,
                                        child: new Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            new CupertinoActivityIndicator(
                                              animating: true,
                                              radius: 8.0,
                                            ),
                                            new Text('Fetching tracks ....',
                                            style: new TextStyle(color: Colors.grey, fontSize: 18.0, fontWeight: FontWeight.bold),
                                            ),
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
                                    return new Container(
                                        height: MediaQuery.of(context).size.height*0.10,
                                        child: new Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            new Icon(Icons.music_note_rounded, size: 30.0, color: Colors.grey),
                                            new Text('No track uploaded.',
                                            style: new TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    if(snapshot.data.documents.isEmpty) {
                                    return new Container(
                                        height: MediaQuery.of(context).size.height*0.10,
                                        child: new Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            new Icon(Icons.music_note_rounded, size: 30.0, color: Colors.grey),
                                            new Text('No track uploaded.',
                                            style: new TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                return new Container(
                                child: new ListView.builder(
                                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                  controller: _artistListTracks,
                                  scrollDirection: Axis.horizontal,
                                  physics: new ScrollPhysics(),
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    DocumentSnapshot ds = snapshot.data.documents[index];
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
                                                  
                                                },
                                              child: new Container(
                                                height: MediaQuery.of(context).size.height*0.15,
                                                width: MediaQuery.of(context).size.height*0.15,
                                                decoration: new BoxDecoration(
                                                  color: Colors.grey[900].withOpacity(0.7),
                                                  border: new Border.all(
                                                    width: 2.0,
                                                    color: _trackChoosenToListen == ds.data()['fileMusicURL']
                                                    ? Colors.purpleAccent
                                                    : Colors.transparent,
                                                  ),
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
                                                    new Positioned(
                                                      top: 0.0,
                                                      left: 0.0,
                                                      right: 0.0,
                                                      bottom: 0.0,
                                                      child: new Container(
                                                        child: new Center(
                                                          child:
                                                          _trackChoosenToListen == ds.data()['fileMusicURL'] && _audioIsOnPause == true
                                                          ? new Container(
                                                            decoration: new BoxDecoration(
                                                              color: Colors.white.withOpacity(0.3),
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: new Padding(
                                                              padding: EdgeInsets.all(7.0),
                                                              child: new IconButton(
                                                                icon: new Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30.0), 
                                                                onPressed: () {
                                                                  setState(() {
                                                                    audioPlayer.resume();
                                                                    _audioIsOnPause = false;
                                                                  });
                                                                  modalSetState((){
                                                                    _audioIsOnPause = false;
                                                                  });
                                                                },
                                                                ),
                                                            ),
                                                          )
                                                           : _trackChoosenToListen == ds.data()['fileMusicURL'] && _audioIsOnPause == false
                                                           ? new Container(
                                                            decoration: new BoxDecoration(
                                                              color: Colors.white.withOpacity(0.3),
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: new Padding(
                                                              padding: EdgeInsets.all(7.0),
                                                              child: new IconButton(
                                                                icon: new Icon(Icons.pause, color: Colors.white, size: 30.0), 
                                                                onPressed: () {
                                                                  setState(() {
                                                                    audioPlayer.pause();
                                                                    _audioIsOnPause = true;
                                                                  });
                                                                  modalSetState((){
                                                                    _audioIsOnPause = true;
                                                                  });
                                                                },
                                                                ),
                                                            ),
                                                          )
                                                           : new Container(
                                                            decoration: new BoxDecoration(
                                                              color: Colors.white.withOpacity(0.3),
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: new Padding(
                                                              padding: EdgeInsets.all(7.0),
                                                              child: new IconButton(
                                                                icon: new Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30.0), 
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _trackChoosenToListen = ds.data()['fileMusicURL'];
                                                                    audioPlayerControllerPosition = 0;
                                                                    audioPlayerControllerDuration = ds.data()['fileMusicDuration'];
                                                                    currentArtistPlayedUsername = ds.data()['artistUsername'];
                                                                    currenProfilePhotoArtistPlayed = ds.data()['artistProfilePhoto'];
                                                                    currentArtistUIDPlayed = ds.data()['artistUID'];
                                                                    currentCoverImagePlayed = ds.data()['coverImage'];
                                                                    currentTitlePlayed = ds.data()['title'];
                                                                  });
                                                                  modalSetState(() {
                                                                    _trackChoosenToListen = ds.data()['fileMusicURL'];
                                                                    audioPlayerControllerPosition = 0;
                                                                    audioPlayerControllerDuration = ds.data()['fileMusicDuration'];
                                                                    currentArtistPlayedUsername = ds.data()['artistUsername'];
                                                                    currenProfilePhotoArtistPlayed = ds.data()['artistProfilePhoto'];
                                                                    currentArtistUIDPlayed = ds.data()['artistUID'];
                                                                    currentCoverImagePlayed = ds.data()['coverImage'];
                                                                    currentTitlePlayed = ds.data()['title'];                                                                  });
                                                                  audioPlayer.play(ds.data()['fileMusicURL'], volume: 1.0).whenComplete(() {
                                                                  });
                                                                },
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
                                              new Container(
                                                child: new Text(ds.data()['title'] != null
                                                ? ds.data()['title'] 
                                                : 'Unknown',
                                                style: new TextStyle(color:
                                                _trackChoosenToListen == ds.data()['fileMusicURL'] 
                                                ? Colors.purpleAccent
                                                : Colors.grey[700],
                                                fontSize: 10.0, fontWeight: FontWeight.w500),
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
                                ),
                                    );
                                  }),
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
              child: new Container(
                height: MediaQuery.of(context).size.height*0.075,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[900],
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
               new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Container(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        new Container(
                          height: MediaQuery.of(context).size.height*0.07,
                          width: MediaQuery.of(context).size.height*0.08,
                          child: currentCoverImagePlayed != null
                          ? new Image.network(currentCoverImagePlayed, fit: BoxFit.cover)
                          : new Container(),
                        ),
                        //Divider
                        new Container(
                          height: MediaQuery.of(context).size.height*0.07,
                          width: MediaQuery.of(context).size.width*0.04,
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.07,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new Container(
                                width: MediaQuery.of(context).size.width*0.50,
                                color: Colors.transparent,
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    new Text(currentArtistPlayedUsername != null
                                    ? currentArtistPlayedUsername
                                    : 'Unknown',
                                    style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              new Container(
                                width: MediaQuery.of(context).size.width*0.50,
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    new Text(currentTitlePlayed != null
                                    ? currentTitlePlayed.toString()
                                    : 'Unknown', 
                                    style: new TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ),
                        new Container(
                          height: MediaQuery.of(context).size.height*0.07,
                          width: MediaQuery.of(context).size.width*0.28,
                          color: Colors.transparent,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new IconButton(
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: new Icon(_audioIsOnPause == false ? Icons.pause_outlined : Icons.play_arrow_rounded, color: Colors.white, size: 30.0), 
                                onPressed: () {
                                  if(_audioIsOnPause == false) {
                                    setState(() {
                                      _audioIsOnPause = true;
                                    });
                                     audioPlayer.pause();
                                  } else {
                                    setState(() {
                                      _audioIsOnPause = false;
                                    });
                                     audioPlayer.resume();
                                  }
                                },
                                ),
                              new IconButton(
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: new Icon(Icons.close, color: Colors.white, size: 30.0), 
                                onPressed: () {
                                  setState(() {
                                    _audioIsOnPause = false;
                                    audioPlayer.stop();
                                    _trackChoosenToListen = '';
                                    _audioLaunched = false;
                                  });
                                },
                                ),
                            ],
                          ),
                        ),
                        ],
                      ),
                    ),
                  ],
                ),
                 new Container(
                   child: new LinearProgressIndicator(
                     backgroundColor: Colors.grey,
                     valueColor: new AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
                     value: audioPlayerControllerPosition/audioPlayerControllerDuration,
                   ),
                 ),
                ],
                ),
              ),
              ),
              new Container(
                height: MediaQuery.of(context).size.height*0.10,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
            ],
          ),
          )
          : new Container(),
        ],
       ),
        ),
      ),
    );
  }

  submiToAProject(String adminUID ,String projectID, String musicStyle, Map<String,dynamic> mapOfSubmissions) {
    FirebaseFirestore.instance
      .collection('users')
      .doc(adminUID)
      .collection('projects')
      .doc(projectID)
      .collection('submissions')
      .doc(widget.currentUser)
      .set({
        'projectID': projectID,
        'senderUID': widget.currentUser,
        'senderPhoto': widget.currentUserPhoto,
        'senderUsername': widget.currentUserUsername,
        'state': 'inWaiting',
      }).whenComplete(() {
        setState(() {
          mapOfSubmissions[widget.currentUser] = 'inWaiting';
        });
        FirebaseFirestore.instance
          .collection(musicStyle)
          .doc(projectID)
          .update({
            'submissions': mapOfSubmissions,
          });
        print('Cloud Firestore : submission stored.');
      });
  }
}