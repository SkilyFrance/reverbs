import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:SONOZ/permissionsHandler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
//import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

class MyMusicDetailsPage extends StatefulWidget {

  //InjectionsData
  String currentUser;
  String artistUID;
  String currentUserUsername;
  AudioPlayer audioPlayerController;
  int index;
  int totalLikes;
  Map<dynamic, dynamic> songsLikedMap;
  int audioPlayerControllerDuration;

  MyMusicDetailsPage({
    Key key,
    this.artistUID,
    this.currentUser,
    this.audioPlayerController,
    this.index,
    this.currentUserUsername,
    this.totalLikes,
    this.songsLikedMap,
    this.audioPlayerControllerDuration,
    }) : super (key: key);


  @override
  MyMusicDetailsPageState createState() => MyMusicDetailsPageState();
}

class MyMusicDetailsPageState extends State<MyMusicDetailsPage> {

  //Position of widget.audioPlayerController
  int audioPlayerControllerPosition = 0;
  int audioPlayerControllerDuration = 275;

  TextEditingController _commentTextEditingControler = new TextEditingController();
  ScrollController _textFieldCommentScrollController = new ScrollController();
  ScrollController commentListView = new ScrollController(initialScrollOffset: 0.0);
  PageController _createStoryController = new PageController(initialPage: 0, viewportFraction: 1);
  PageController _listMusicController;

  //Variables to create a story
  AudioPlayer audioPlayerStory = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool showSetupToScreenshot = false;
  bool audioIsOnPause = false;
  double durationAudio;
  double startDuration = 0.0;
  double differenceBetween;
  int currentSeekUpdate = 0;
  double newValueMax;
  Duration more15seconds = new Duration(seconds: 15);
  bool _startRecordScreen = false;

  //Variables to increment views after watchin (onChanged, pageView.Builder)
  String musicCurrentStyle;
  String musicCurrentTimeStamp;
  int musicCurrentViews;
  String musicCurrentArtistUID;



  _launchURL(String link) async {
    if(await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  //
  Timer _timerSelectExtract;
  int _startSelectExtract = 0;
  //
void timerToSelectExtractStory() {
  const oneSec = const Duration(milliseconds: 1);
  _timerSelectExtract = new Timer.periodic(
    oneSec,
    (Timer timer) {
      if (_startSelectExtract == 15000) {
        audioPlayerStory.seek(new Duration(milliseconds: currentSeekUpdate));
        if(this.mounted){
          setState(() {
            _startSelectExtract = 0;
          });
        }
      } else {
        if(this.mounted) {
        setState(() {
          _startSelectExtract++;
        });
        }
      }
    },
  );
}


  //
  Timer _timerToCreateStory;
  int _startToCreateStory = 0;
  //
void timerForExtractStory() {
  const oneSec = const Duration(milliseconds: 1);
  _timerToCreateStory = new Timer.periodic(
    oneSec,
    (Timer timer) async {
      if (_startToCreateStory == 15000) {
        await FlutterScreenRecording.stopRecordScreen.whenComplete(() {
        audioPlayerStory.stop();
        _createStoryController.nextPage(duration: new Duration(microseconds: 1), curve: Curves.bounceIn);
        if(this.mounted){
          setState(() {
            _timerToCreateStory.cancel();
            _startRecordScreen = false;
            _startToCreateStory = 0;
            print('Screenshot is ready');
          });
        }
        }).catchError((error) => print('Error = $error'));
      } else {
        if(this.mounted) {
        setState(() {
          _startToCreateStory++;
        });
        }
      }
    },
  );
}









  

  @override
  void initState() {
    widget.audioPlayerController.onAudioPositionChanged.listen((event) {
      setState(() {
        audioPlayerControllerPosition = event.inMilliseconds;
      });
    });
    _listMusicController = new PageController(viewportFraction: 1, initialPage: widget.index);
    super.initState();
  }
  @override
  void dispose() {
    widget.audioPlayerController.dispose();
    audioPlayerStory.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xFF121212),
        child: new StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').doc(widget.artistUID).collection('songs').orderBy('timestamp', descending: true).snapshots(),
          builder: (BuildContext context, snapshot) {
          if(snapshot.hasError) {
            return new Container(
              color: Colors.black,
              child: new Center(child: new Text('Buddy, check your internet network.', style: new TextStyle(color: Colors.yellowAccent, fontSize: 15.0, fontWeight: FontWeight.bold))));
          }
          if(!snapshot.hasData) {
            return new Container();
          }
          if(snapshot.data.documents.isEmpty) {
            return new Container(
              height: MediaQuery.of(context).size.height*0.35,
              width: MediaQuery.of(context).size.width,
            );
            }
        return new Container(
          child: new WillPopScope(
            onWillPop: () async {
              widget.audioPlayerController.stop();
              Navigator.pop(context, false);
              print('ok user pop');
              return false;
            },
        child: new Stack(
          children: [
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: new PageView.builder(
                physics: showSetupToScreenshot == false ? new ScrollPhysics() : new NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: _listMusicController,
                itemCount: snapshot.data.documents.length,
                onPageChanged: (value) {
                  setState(() {
                    widget.audioPlayerControllerDuration = snapshot.data.documents[value]['fileMusicDuration'];
                    audioPlayerControllerPosition = 0;
                  });
                  widget.audioPlayerController.play(snapshot.data.documents[value]['fileMusicURL'], volume: 1.0);
                  viewRequest(
                    snapshot.data.documents[value]['style'], 
                    snapshot.data.documents[value]['timestamp'], 
                    snapshot.data.documents[value]['views'], 
                    snapshot.data.documents[value]['artistUID']);
                },
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot ds = snapshot.data.documents[index];
                  return new Container(
                child: new Stack(
                children: [
                  //ImageContainer
                  new Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: ds.data()['imageSong'] != null
                    ? new Image.network(ds.data()['imageSong'], fit: BoxFit.cover)
                    : new Container(),
                    ),
                  new Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        new Container(
                          height: MediaQuery.of(context).size.height*0.40,
                          width: MediaQuery.of(context).size.width,
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black, Colors.black.withOpacity(0.0)]
                            ),
                          ),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //Divider
                              new Container(
                              height: MediaQuery.of(context).size.height*0.09,
                              color: Colors.transparent,
                              ),
                              new Container(
                              height: MediaQuery.of(context).size.height*0.06,
                              color: Colors.transparent,
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  //Divider
                                  new Container(
                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.05,
                                  color: Colors.transparent,
                                  ),
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.04,
                                    width: MediaQuery.of(context).size.height*0.04,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.circular(50.0),
                                    ),
                                    child: new ClipOval(
                                      child: ds.data()['artistProfilePhoto'] != null
                                      ? new Image.network(ds.data()['artistProfilePhoto'], fit: BoxFit.cover)
                                      : new Container(),
                                    ),
                                  ),
                                  //Divider
                                  new Container(
                                  height: MediaQuery.of(context).size.height*0.05,
                                  width: MediaQuery.of(context).size.width*0.02,
                                  color: Colors.transparent,
                                  ),
                                  new Container(
                                  height: MediaQuery.of(context).size.height*0.04,
                                  color: Colors.transparent,
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      new Container(
                                        height: MediaQuery.of(context).size.height*0.04,
                                      child: new Center(
                                      child: new Text(
                                        ds.data()['artistUsername'] != null
                                        ? '@${ds.data()['artistUsername']} - '
                                        : '',
                                      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),
                                      ),
                                      ),
                                      ),
                                      new Container(
                                        height: MediaQuery.of(context).size.height*0.04,
                                      child: new Center(
                                      child: new Text(
                                        ds.data()['title'] != null
                                        ? '${ds.data()['title']}'
                                        : '',
                                      style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w500),
                                      ),
                                      ),
                                      ),
                                    ],
                                  ),
                                  ),
                                ],
                              ),
                              ),
                              new Container(
                                height: MediaQuery.of(context).size.height*0.06,
                                color: Colors.transparent,
                                child: new Container(
                                  color: Colors.transparent,
                                  child: new SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                  child: new Padding(
                                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: new ReadMoreText(
                                    ds.data()['description'] != null
                                    ? "${ds.data()['description']}"
                                    : "",
                                  textAlign: TextAlign.justify,
                                  style: new TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal,
                                  ),
                                  delimiter: '  ',
                                  trimLines: 2,
                                  colorClickableText: Colors.yellowAccent,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Show more',
                                  trimExpandedText: 'Show less',
                                  lessStyle: new TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.yellowAccent),
                                  moreStyle: new TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.yellowAccent))),
                                ),
                                ),
                              ),
                              new Container(
                                height: MediaQuery.of(context).size.height*0.01,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ),
                    new Positioned(
                      top: 0.0,
                      left: 0.0,
                      right: 0.0,
                      bottom: 0.0,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          new Container(
                            height: MediaQuery.of(context).size.height*0.10,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.transparent,
                          ),
                          new Container(
                            height: MediaQuery.of(context).size.height*0.55,
                            color: Colors.transparent,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  height: MediaQuery.of(context).size.height*0.65,
                                  width: MediaQuery.of(context).size.width*0.75,
                                  color: Colors.transparent,
                                ),
                                //Tap pause /replay
                                new Container(
                                  height: MediaQuery.of(context).size.height*0.65,
                                  width: MediaQuery.of(context).size.width*0.25,
                                  color: Colors.transparent,
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      new Container(
                                      height: MediaQuery.of(context).size.height*0.30,
                                      width: MediaQuery.of(context).size.width*0.25,
                                      child: new Stack(
                                        children: [
                                          new Positioned(
                                            top: 0.0,
                                            left: 0.0,
                                            right: 0.0,
                                            bottom: 0.0,
                                            child: new Container(
                                              height: MediaQuery.of(context).size.height*0.30,
                                              width: MediaQuery.of(context).size.width*0.25,
                                              color: Colors.transparent,
                                              ),
                                          ),
                                          new Positioned(
                                            top: 0.0,
                                            right: 0.0,
                                            left: 0.0,
                                            bottom: 0.0,
                                            child: new ClipRRect(
                                              child: new BackdropFilter(
                                                filter: new ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                                                child: new Container(
                                                  decoration: new BoxDecoration(
                                                    color: Colors.black.withOpacity(0.1),
                                                    borderRadius: new BorderRadius.only(
                                                      topLeft: Radius.circular(20.0),
                                                      bottomLeft: Radius.circular(20.0),
                                                    ),
                                                  ),
                                                ),
                                                ),
                                            ),
                                            ),
                                          new Positioned(
                                            top: 0.0,
                                            left: 0.0,
                                            right: 0.0,
                                            bottom: 0.0,
                                            child: new Container(
                                              height: MediaQuery.of(context).size.height*0.30,
                                              width: MediaQuery.of(context).size.width*0.25,
                                              color: Colors.transparent,
                                              child: new Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  //LikeButton
                                                  new InkWell(
                                                    onTap: () {
                                                      if(widget.songsLikedMap.containsValue(ds.data()['timestamp'])) {
                                                        unlikeRequest(ds.data()['style'], ds.data()['timestamp'], ds.data()['likes'], widget.totalLikes ,ds.data()['artistUID']);
                                                      } else {
                                                        likeRequest(ds.data()['style'], ds.data()['timestamp'], ds.data()['likes'], widget.totalLikes ,ds.data()['artistUID']);
                                                      }
                                                    },
                                                    child: new Container(
                                                      height: MediaQuery.of(context).size.height*0.10,
                                                      width: MediaQuery.of(context).size.width*0.25,
                                                      color: Colors.transparent,
                                                      child: new Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                        new Image.asset(
                                                          widget.songsLikedMap.containsValue(ds.data()['timestamp'])
                                                          ? 'lib/assets/like.png'
                                                          : 'lib/assets/likeOff.png',
                                                          height: 30.0,
                                                          width: 30.0,
                                                          color: Colors.white,
                                                        ),
                                                        new Text(
                                                          ds.data()['likes']!= null
                                                          ? '${ds.data()['likes'].toString()}'
                                                          : '',
                                                        style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                      ),
                                                    ),
                                                  ),
                                                  //CommentButton
                                                  new InkWell(
                                                    onTap: () {
                                                    showCupertinoModalBottomSheet(
                                                      animationCurve: Curves.decelerate,
                                                      context: context,
                                                      builder: (context) =>
                                                      new Material(
                                                        color: Colors.transparent,
                                                      child: new Container(
                                                        height: MediaQuery.of(context).size.height*0.55,
                                                        width: MediaQuery.of(context).size.width,
                                                        color: Colors.black,
                                                        child: new Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            new Container(
                                                              height: MediaQuery.of(context).size.height*0.43,
                                                              width: MediaQuery.of(context).size.width,
                                                        child: new StreamBuilder(
                                                          stream: FirebaseFirestore.instance.collection(ds.data()['style']).doc(ds.data()['timestamp']).collection('comments').orderBy('timestamp', descending: false).snapshots(),
                                                          builder: (BuildContext context, snapshot) {
                                                          if(snapshot.hasError) {
                                                            return new Center(
                                                              child: new Text('Check your internet network buddy.', style: new TextStyle(color: Colors.yellowAccent, fontWeight: FontWeight.bold)),
                                                            );
                                                          }
                                                          if(!snapshot.hasData) {
                                                            return new Container();
                                                          }
                                                          if(snapshot.data.documents.isEmpty) {
                                                            return new Container(
                                                              height: MediaQuery.of(context).size.height*0.10,
                                                              width: MediaQuery.of(context).size.width,
                                                              child: new Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                              new Text('No comment yet.', style: new TextStyle(color: Colors.yellowAccent,fontSize: 18.0, fontWeight: FontWeight.bold)),
                                                              new Text('Be first buddy', style: new TextStyle(color: Colors.yellow[200],fontSize: 15.0, fontWeight: FontWeight.w600)),
                                                              ]));
                                                          }
                                                          return new Container(
                                                            child: new Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                  new Container(
                                                                    height: MediaQuery.of(context).size.height*0.07,
                                                                    width: MediaQuery.of(context).size.width,
                                                                    child: new Center(
                                                                      child: new Text(
                                                                          snapshot.data.documents.length != null 
                                                                        ? '${snapshot.data.documents.length} comments'
                                                                        : '',
                                                                        style: new TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  //ListView
                                                                  new Container(
                                                                    height: MediaQuery.of(context).size.height*0.34,
                                                                    width: MediaQuery.of(context).size.width,
                                                                    child: new ListView.builder(
                                                                    scrollDirection: Axis.vertical,
                                                                    controller: commentListView,
                                                                    shrinkWrap: true,
                                                                    itemCount: snapshot.data.documents.length,
                                                                    reverse: false,
                                                                    itemBuilder: (BuildContext context, int index) {
                                                                      //DocumentReference ds = snapshot.data.documents[index];
                                                                      return new ListTile(
                                                                        leading: new Text(
                                                                          snapshot.data.documents[index]['userName'] != null
                                                                          ? snapshot.data.documents[index]['userName']
                                                                          : 'unknown',
                                                                        style: new TextStyle(color: Colors.yellowAccent, fontSize: 13.0, fontWeight: FontWeight.bold),
                                                                        ),
                                                                        title: new Text(
                                                                          snapshot.data.documents[index]['comments'] != null
                                                                          ? snapshot.data.documents[index]['comments']
                                                                          : '(message)',
                                                                        style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.normal)),
                                                                      );
                                                                    }),
                                                                  ),
                                                              ],
                                                            ),
                                                          );
                                                          },
                                                          ),
                                                            ),
                                                          //TextFielToComment
                                                          new Container(
                                                          height: MediaQuery.of(context).size.height*0.07,
                                                          width: MediaQuery.of(context).size.width,
                                                          color: Colors.grey[900].withOpacity(0.4),
                                                          child: new Center(
                                                          child: new TextField(
                                                            scrollController: _textFieldCommentScrollController,
                                                            maxLines: null,
                                                            minLines: 1,
                                                            style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.normal),
                                                            cursorColor: Colors.yellowAccent,
                                                            controller: _commentTextEditingControler,
                                                            decoration: new InputDecoration(
                                                              suffixIcon: new IconButton(
                                                                iconSize: 20.0,
                                                                onPressed: (){
                                                                  if(_commentTextEditingControler.text.length > 2) {
                                                                    print('send a comment');
                                                                    commentRequest(ds.data()['artistUID'], ds.data()['style'], ds.data()['timestamp'], widget.currentUserUsername, ds.data()['comments']);
                                                                  } else {
                                                                    print('No comment to send');
                                                                  }
                                                                },
                                                                icon: new Icon(Icons.send),
                                                                color: Colors.yellowAccent,
                                                                splashColor: Colors.transparent,
                                                              ),
                                                              contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
                                                              hintText: 'Your comment',
                                                              hintStyle: new TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.normal),
                                                              border: new OutlineInputBorder(
                                                                borderSide: BorderSide.none,
                                                              ),
                                                              focusedBorder: new OutlineInputBorder(
                                                                borderSide: BorderSide.none,
                                                              ),
                                                              enabledBorder:  new OutlineInputBorder(
                                                                borderSide: BorderSide.none,
                                                              ),
                                                            ),
                                                          ),
                                                          ),
                                                          ),
                                                          ],
                                                        ),
                                                      ),
                                                      ),
                                                    );
                                                    },
                                                    child: new Container(
                                                      height: MediaQuery.of(context).size.height*0.10,
                                                      width: MediaQuery.of(context).size.width*0.25,
                                                      color: Colors.transparent,
                                                      child: new Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                        new Image.asset('lib/assets/comment.png',
                                                          height: 30.0,
                                                          width: 30.0,
                                                          color: Colors.white,
                                                        ),
                                                        new Text(
                                                          ds.data()['comments'] != null
                                                          ? '${ds.data()['comments'].toString()}'
                                                          : '',
                                                        style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                      ),
                                                    ),
                                                  ),
                                                  //ShareButton
                                                  new InkWell(
                                                    onTap: () async {
                                                    if(Platform.isIOS) {
                                                      var storagePermission = await Permission.mediaLibrary.status;
                                                      if(storagePermission.isGranted) {
                                                       if(this.mounted) {
                                                        setState(() {
                                                          showSetupToScreenshot = true;
                                                        });
                                                       }
                                                      } else if(storagePermission.isUndetermined) {
                                                        await Permission.mediaLibrary.request();
                                                        if(await Permission.mediaLibrary.request().isGranted) {
                                                          if(this.mounted) {
                                                            setState(() {
                                                              showSetupToScreenshot = true;
                                                            });
                                                           }
                                                        } else if(await Permission.mediaLibrary.request().isDenied) {
                                                          PermissionDemandClass().iosDialogFile(context);
         
                                                        } else if(await Permission.mediaLibrary.request().isPermanentlyDenied) {
                                                          PermissionDemandClass().iosDialogFile(context);
                                                        }
         
                                                      } else if(storagePermission.isDenied || storagePermission.isPermanentlyDenied) {
                                                        PermissionDemandClass().iosDialogFile(context);
                                                      }
                                                    } else {
                                                    //Android
                                                    var storagePermissionAndroid = await Permission.storage.status;
                                                    if(storagePermissionAndroid.isGranted) {
                                                      if(this.mounted) {
                                                        setState(() {
                                                          showSetupToScreenshot = true;
                                                        });
                                                      }
                                                    } else if(storagePermissionAndroid.isUndetermined) {
                                                      await Permission.storage.request();
                                                      if(await Permission.storage.request().isGranted) {
                                                        if(this.mounted) {
                                                          setState(() {
                                                            showSetupToScreenshot = true;
                                                          });
                                                        }
                                                      } else if(await Permission.storage.request().isDenied) {
                                                        PermissionDemandClass().androidDialogFile(context);

                                                      } else if(await Permission.storage.request().isPermanentlyDenied) {
                                                        PermissionDemandClass().androidDialogFile(context);
                                                      }
                                                      
                                                    } else if(storagePermissionAndroid.isDenied || storagePermissionAndroid.isPermanentlyDenied) {
                                                      PermissionDemandClass().androidDialogFile(context);
                                                    }
                                                        }
                                                          },
                                                    child: new Container(
                                                      height: MediaQuery.of(context).size.height*0.10,
                                                      width: MediaQuery.of(context).size.width*0.25,
                                                      color: Colors.transparent,
                                                      child: new Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                        new Image.asset('lib/assets/share.png',
                                                          height: 30.0,
                                                          width: 30.0,
                                                          color: Colors.white,
                                                        ),
                                                        new Text(
                                                          ds.data()['shares'] != null
                                                          ? '${ds.data()['shares'].toString()}'
                                                          : '',
                                                        style: new TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                    ),
                ],
              ),
            ),
            showSetupToScreenshot == true
            ? new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: new PageView(
                physics: new NeverScrollableScrollPhysics(),
                controller: _createStoryController,
                children: [
                  //1st Page
              new Container(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new Container(
                      height: MediaQuery.of(context).size.height*0.40,
                      width: MediaQuery.of(context).size.width*0.80,
                      decoration: new BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: new BorderRadius.circular(10.0)
                      ),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            new Container(
                              height: MediaQuery.of(context).size.height*0.05,
                              width: MediaQuery.of(context).size.width*0.80,
                            ),
                            new Container(
                              child: new Text('Press "Start" to create a story',
                              style: new TextStyle(color: Colors.yellowAccent, fontSize: 14.0, fontWeight: FontWeight.bold),
                              ),
                          ),
                            new Container(
                              height: MediaQuery.of(context).size.height*0.06,
                              width: MediaQuery.of(context).size.width*0.80,
                            ),
                            new Container(
                              child: new Text('This mode allows you to create a 15sec',
                              style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                              ),
                          ),
                            new Container(
                              height: MediaQuery.of(context).size.height*0.01,
                              width: MediaQuery.of(context).size.width*0.80,
                            ),
                            new Container(
                              child: new Text('video with this track and share it',
                              style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                              )),
                            new Container(
                              height: MediaQuery.of(context).size.height*0.01,
                              width: MediaQuery.of(context).size.width*0.80,
                            ),
                            new Container(
                              child: new Text('on Instagram.',
                              style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.normal),
                              ),
                          ),
                            new Container(
                              height: MediaQuery.of(context).size.height*0.06,
                              width: MediaQuery.of(context).size.width*0.80,
                            ),
                            new InkWell(
                              onTap: () async {
                                widget.audioPlayerController.pause();
                                setState(() {
                                  audioIsOnPause = true;
                                });
                                audioPlayerStory.play(ds.data()['fileMusicURL']).whenComplete(() {
                                  timerToSelectExtractStory();
                                });
                              _createStoryController.nextPage(duration: new Duration(microseconds: 1), curve: Curves.bounceIn);
                              },
                            child: new Container(
                              height: MediaQuery.of(context).size.height*0.05,
                              width: MediaQuery.of(context).size.width*0.5,
                              decoration: new BoxDecoration(
                                color: Colors.yellowAccent,
                                borderRadius: new BorderRadius.circular(5.0),
                              ),
                              child: new Center(
                                child: new Text('START',
                                style: new TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                          )),
                            new Container(
                              height: MediaQuery.of(context).size.height*0.01,
                              width: MediaQuery.of(context).size.width*0.80,
                            ),
                            new FlatButton(
                              onPressed: () {
                                setState(() {
                                  showSetupToScreenshot = false;
                                });
                              },
                              child: new Center(
                                child: new Text('CANCEL',
                                style: new TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //2nd Page
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  new Container(
                    height: MediaQuery.of(context).size.height*0.73,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.9),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new Container(
                          child: new Text('Step 1',
                          style: new TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        new Container(
                          child: new Text('Choose your extract.',
                          style: new TextStyle(color: Colors.grey, fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        new InkWell(
                          onTap: () {
                            setState(() {
                              _startSelectExtract = 0;
                              currentSeekUpdate = (currentSeekUpdate+15000);
                            });
                            _timerSelectExtract.cancel();
                            audioPlayerStory.seek(new Duration(milliseconds: (currentSeekUpdate))).whenComplete(() {
                              timerToSelectExtractStory();
                            });
                          },
                        child: new Container(
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.width*0.40,
                          decoration: new BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: new BorderRadius.circular(10.0)
                          ),
                          child: new Center(
                          child: new Text('+15s',
                          style: new TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.08,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.9),
                    child: new Center(
                      child: new Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: new ClipRRect(
                          borderRadius: new BorderRadius.circular(10.0),
                        child: new LinearProgressIndicator(
                          backgroundColor: Colors.white.withOpacity(0.5),
                          minHeight: 12.0,
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                          value: _startSelectExtract/15000,
                        ),
                        ),
                      ),
                    ),
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height*0.19,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(1.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new FlatButton(
                          onPressed: () {
                            _createStoryController.nextPage(duration: new Duration(microseconds: 1), curve: Curves.bounceIn);
                            audioPlayerStory.stop();
                          _startSelectExtract = 0;
                          _timerSelectExtract.cancel();
                          }, 
                          child: new Text('SELECT THIS EXTRACT',
                          style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          ),
                        new FlatButton(
                          onPressed: () {
                            audioPlayerStory.stop();
                          _startSelectExtract = 0;
                          _timerSelectExtract.cancel();
                          setState(() {
                            showSetupToScreenshot = false;
                          });
                          }, 
                          child: new Text('CANCEL',
                          style: new TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //3rd pageView
              new Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                        child: new Stack(
                          children: [
                            new Positioned(
                              top: 0.0,
                              left: 0.0,
                              right: 0.0,
                              bottom: 0.0,
                              child: ds.data()['imageSong'] != null
                              ? new ClipRRect(
                                borderRadius: new BorderRadius.circular(20.0),
                                child: new Image.network(ds.data()['imageSong'], fit: BoxFit.cover),
                              )
                              : new Container(color: Colors.grey)
                              ),
                            new Positioned(
                              top: 0.0,
                              left: 0.0,
                              right: 0.0,
                              bottom: 0.0,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  new Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.black.withOpacity(0.7),
                                    child: new Center(
                                      child: new Container(
                                        child: new Padding(
                                          padding: EdgeInsets.only(top: 15.0),
                                        child: new Text(
                                          ds.data()['artistUsername'] != null
                                          ? ds.data()['artistUsername']
                                          : 'Unknown',
                                          style: new TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold),
                                          ),
                                      ),
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.black.withOpacity(0.7),
                                    child: new Center(
                                      child: new Container(
                                        child: new Padding(
                                          padding: EdgeInsets.only(bottom: 5.0),
                                        child: new Text(
                                          ds.data()['title'] != null
                                          ? ds.data()['title']
                                          : 'Unknown',
                                          style: new TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w500),
                                          ),
                                      ),
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.05,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.black.withOpacity(0.7),
                                    child: new Center(
                                      child: new Container(
                                        child: new Padding(
                                          padding: EdgeInsets.only(bottom: 5.0),
                                        child: new RichText(
                                          text: new TextSpan(
                                            text: 'Discover on ',
                                            style: new TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
                                            children: [
                                              new TextSpan(
                                                text: 'Reverbs.',
                                                style: new TextStyle(color: Colors.yellowAccent, fontSize: 14.0, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                            ),
                                          ),
                                      ),
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.30,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                            new Positioned(
                              top: 0.0,
                              left: 0.0,
                              right: 0.0,
                              bottom: 0.0,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _startRecordScreen == false
                                  ? new Container(
                                  height: MediaQuery.of(context).size.height*0.19,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.black.withOpacity(1.0),
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      new FlatButton(
                                        onPressed: () async {
                                          if(Platform.isIOS) {
                                            var microphonePermission = await Permission.microphone.status;
                                            if(microphonePermission.isGranted) {
                                            await FlutterScreenRecording.startRecordScreenAndAudio('${DateTime.now().millisecond.toString()}', titleNotification: DateTime.now().millisecond.toString(), messageNotification: DateTime.now().millisecond.toString()).whenComplete(() {
                                              audioPlayerStory.seek(new Duration(milliseconds: (currentSeekUpdate))).whenComplete(() {
                                                timerForExtractStory();
                                              });
                                              if(this.mounted) {
                                              setState(() {
                                                _startRecordScreen = true;
                                              });
                                              }
                                            }).catchError((error) => print('error = $error'));
                                            //
                                            } else if(microphonePermission.isUndetermined) {
                                              await Permission.microphone.request();
                                              if(await Permission.microphone.request().isGranted) {
                                              //
                                            await FlutterScreenRecording.startRecordScreenAndAudio('${DateTime.now().millisecond.toString()}', titleNotification: DateTime.now().millisecond.toString(), messageNotification: DateTime.now().millisecond.toString()).whenComplete(() {
                                              audioPlayerStory.seek(new Duration(milliseconds: (currentSeekUpdate))).whenComplete(() {
                                                timerForExtractStory();
                                              });
                                              if(this.mounted) {
                                              setState(() {
                                                _startRecordScreen = true;
                                              });
                                              }
                                            }).catchError((error) => print('error = $error'));
                                            //
                                              } else if (await Permission.microphone.request().isDenied) {
                                                PermissionDemandClass().iosDialogMicro(context);
                                              } else if (await Permission.microphone.request().isPermanentlyDenied) {
                                                PermissionDemandClass().iosDialogMicro(context);
                                              }
                                            } else if(microphonePermission.isDenied || microphonePermission.isPermanentlyDenied) {
                                              PermissionDemandClass().iosDialogMicro(context);
                                            }
                                          } else {
                                            //Android
                                            var microphonePermissionAndroid = await Permission.microphone.status;
                                            if(microphonePermissionAndroid.isGranted) {
                                            await FlutterScreenRecording.startRecordScreenAndAudio('${DateTime.now().millisecond.toString()}', titleNotification: DateTime.now().millisecond.toString(), messageNotification: DateTime.now().millisecond.toString()).whenComplete(() {
                                              audioPlayerStory.seek(new Duration(milliseconds: (currentSeekUpdate))).whenComplete(() {
                                                timerForExtractStory();
                                              });
                                              if(this.mounted) {
                                              setState(() {
                                                _startRecordScreen = true;
                                              });
                                              }
                                            }).catchError((error) => print('error = $error'));
                                            //
                                            } else if(microphonePermissionAndroid.isUndetermined){
                                              await Permission.microphone.request();
                                              if(await Permission.microphone.request().isGranted) {
                                                  //
                                                  await FlutterScreenRecording.startRecordScreenAndAudio('${DateTime.now().millisecond.toString()}', titleNotification: DateTime.now().millisecond.toString(), messageNotification: DateTime.now().millisecond.toString()).whenComplete(() {
                                                    audioPlayerStory.seek(new Duration(milliseconds: (currentSeekUpdate))).whenComplete(() {
                                                      timerForExtractStory();
                                                    });
                                                    if(this.mounted) {
                                                    setState(() {
                                                      _startRecordScreen = true;
                                                    });
                                                    }
                                                  }).catchError((error) => print('error = $error'));
                                                  //
                                              } else if(await Permission.microphone.request().isDenied) {
                                                PermissionDemandClass().androidDialogMicro(context);

                                              } else if(await Permission.microphone.request().isPermanentlyDenied) {
                                                PermissionDemandClass().androidDialogMicro(context);
                                              }

                                            } else if(microphonePermissionAndroid.isDenied || microphonePermissionAndroid.isPermanentlyDenied) {
                                              PermissionDemandClass().androidDialogMicro(context);
                                            }
                                          }
                                        }, 
                                        child: new Text('CREATE STORY',
                                        style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
                                        ),
                                        ),
                                      new FlatButton(
                                        onPressed: () {
                                        audioPlayerStory.stop();
                                        setState(() {
                                          showSetupToScreenshot = false;
                                        });
                                        }, 
                                        child: new Text('CANCEL',
                                        style: new TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : new Container(
                                  height: MediaQuery.of(context).size.height*0.30,
                                  width: MediaQuery.of(context).size.width,
                                  child: new Center(
                                    child:  new Padding(
                                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                      child: new ClipRRect(
                                        borderRadius: new BorderRadius.circular(10.0),
                                      child: new LinearProgressIndicator(
                                      backgroundColor: Colors.black.withOpacity(0.8),
                                      minHeight: 12.0,
                                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                                      value: _startToCreateStory/15000,
                                      ),
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
                      //4th container (Story is stored in Device)
                      new Container(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            new Container(
                              height: MediaQuery.of(context).size.height*0.40,
                              width: MediaQuery.of(context).size.width*0.80,
                              decoration: new BoxDecoration(
                                color: Colors.black.withOpacity(0.9),
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  //Divider
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.06,
                                    width: MediaQuery.of(context).size.width*0.80,
                                  ),
                                  new Text('Great buddy !',
                                  style: new TextStyle(color: Colors.yellowAccent, fontSize: 19.0, fontWeight: FontWeight.bold),
                                  ),
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.08,
                                    width: MediaQuery.of(context).size.width*0.80,
                                  ),
                                  new Text('Story stored in your phone.',
                                  style: new TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.07,
                                    width: MediaQuery.of(context).size.width*0.80,
                                  ),
                                  new InkWell(
                                    onTap: () {
                                      _launchURL('https://www.instagram.com/');
                                      shareRequest(ds.data()['style'], ds.data()['timestamp'], ds.data()['shares'],ds.data()['artistUID']);
                                    },
                                  child: new Container(
                                    height: MediaQuery.of(context).size.height*0.055,
                                    width: MediaQuery.of(context).size.width*0.45,
                                    decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.circular(10.0),
                                      color: Colors.yellowAccent,
                                    ),
                                    child: new Center(
                                      child: new Text('PUBLISH ON INSTAGRAM',
                                      style: new TextStyle(color: Colors.black, fontSize: 11.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  ),
                                  new Container(
                                    height: MediaQuery.of(context).size.height*0.02,
                                    width: MediaQuery.of(context).size.width*0.80,
                                  ),
                                  new FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        showSetupToScreenshot = false;
                                      });
                                    }, 
                                    child: new Text('PUBLISH LATER',
                                      style: new TextStyle(color: Colors.grey, fontSize: 11.0, fontWeight: FontWeight.bold),
                                    ),
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              )
            : new Container(),
                  ],
                  ),
                  );
                },
              ),
              ),
          new Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                  new AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                  ),
                  ],
                ),
                ),
                showSetupToScreenshot == false
                ? new Positioned(
                  top: 0.0,
                  right: 0.0,
                  left: 0.0,
                  bottom: 0.0,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      new Container(
                        height: MediaQuery.of(context).size.height*0.22,
                        width: MediaQuery.of(context).size.width,
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Divider
                            new Container(
                              height: MediaQuery.of(context).size.height*0.07,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.transparent,
                            ),
                            widget.audioPlayerControllerDuration != null && audioPlayerControllerPosition != null
                            ? new Container(
                              height: MediaQuery.of(context).size.height*0.15,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.transparent,
                              child: new Stack(
                                children: [
                                  new Positioned(
                                    top: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    bottom: 0.0,
                                     child: new LinearProgressIndicator(
                                       backgroundColor: Colors.transparent,
                                       valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                                       value: audioPlayerControllerPosition/ widget.audioPlayerControllerDuration,
                                     ),
                                    ),
                                   new Positioned(
                                     top: 0.0,
                                     left: 0.0,
                                     right: 0.0,
                                     bottom: 0.0,
                                     child: new Column(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         new Container(
                                           height: MediaQuery.of(context).size.height*0.01,
                                           width: MediaQuery.of(context).size.width,
                                           color: Colors.transparent,
                                         ),
                                         new Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                           children: [
                                             new InkWell(
                                               onTap: (){
                                                 widget.audioPlayerController.seek(new Duration(seconds: 0));
                                               },
                                             child: new Container(
                                               height: MediaQuery.of(context).size.height*0.06,
                                               width: MediaQuery.of(context).size.height*0.06,
                                               decoration: new BoxDecoration(
                                                 shape: BoxShape.circle,
                                                 color: Colors.yellowAccent,
                                               ),
                                               child: new Center(
                                                 child: new Image.asset('lib/assets/returnButton.png',
                                                   height: MediaQuery.of(context).size.height*0.03,
                                                   width: MediaQuery.of(context).size.height*0.03,
                                                 ),
                                               ),
                                             ),
                                             ),
                                             new InkWell(
                                               onTap: () {
                                                 if(audioIsOnPause == true) {
                                                   widget.audioPlayerController.resume();
                                                   setState(() {
                                                     audioIsOnPause = false;
                                                   });
                                                 } else {
                                                   widget.audioPlayerController.pause();
                                                   setState(() {
                                                     audioIsOnPause = true;
                                                   });
                                                 }
                                               },
                                             child: new Container(
                                               height: MediaQuery.of(context).size.height*0.06,
                                               width: MediaQuery.of(context).size.height*0.06,
                                               decoration: new BoxDecoration(
                                                 shape: BoxShape.circle,
                                                 color: Colors.yellowAccent,
                                               ),
                                               child: new Center(
                                                 child: new Image.asset(
                                                   audioIsOnPause == false 
                                                   ? 'lib/assets/pause.png'
                                                   : 'lib/assets/play.png',
                                                   height: MediaQuery.of(context).size.height*0.025,
                                                   width: MediaQuery.of(context).size.height*0.025,
                                                 ),
                                               ),
                                               ),
                                             ),
                                             new InkWell(
                                               onTap: (){
                                                 widget.audioPlayerController.seek(new Duration(milliseconds: audioPlayerControllerPosition+15000));
                                               },
                                             child: new Container(
                                               height: MediaQuery.of(context).size.height*0.06,
                                               width: MediaQuery.of(context).size.height*0.06,
                                               decoration: new BoxDecoration(
                                                 shape: BoxShape.circle,
                                                 color: Colors.yellowAccent,
                                               ),
                                               child: new Center(
                                                 child: new Image.asset('lib/assets/forward.png',
                                                   height: MediaQuery.of(context).size.height*0.025,
                                                   width: MediaQuery.of(context).size.height*0.025,
                                                 ),
                                               ),
                                             ),
                                             ),
                                           ],
                                         ),
                                       ],
                                     ),
                                   ),
                                ],
                              ),
                            ) 
                            : new Container(),
                          ],
                        ),
                      ),
                    ],
                ),
                )
                : new Container(),
          ],
        ),
          ),
            );
          }
    ),
    ),
    );
  }



  shareRequest(String musicStyle, String timeStamp, int shares, String artistUID) {
    FirebaseFirestore.instance
      .collection(musicStyle)
      .doc(timeStamp)
      .update({
        'shares': shares+1,
      }).whenComplete(() {
        FirebaseFirestore.instance
          .collection('users')
          .doc(artistUID)
          .collection('songs')
          .doc(timeStamp)
          .update({
            'shares': shares+1,
          }).whenComplete(() {
            print('Ok shares +1 (stored)');
          });
      });
  }


    commentRequest(String artistUID,String musicStyle, String timeStamp, String currentUserUsername, int comments) {
    String commentTimeStamp = DateTime.now().microsecondsSinceEpoch.toString();
    print('commentTimeStamp = $commentTimeStamp');
    FirebaseFirestore.instance
      .collection(musicStyle)
      .doc(timeStamp)
      .collection('comments')
      .doc(commentTimeStamp)
      .set({
        'userName': currentUserUsername,
        'userUID': widget.currentUser,
        'comments': _commentTextEditingControler.value.text,
        'timestamp': commentTimeStamp,
      }).whenComplete(() {
        _commentTextEditingControler.clear();
        FirebaseFirestore.instance
          .collection(musicStyle)
          .doc(timeStamp)
          .update({
            'comments': comments+1,
          });
          }).whenComplete(() {
          FirebaseFirestore.instance
            .collection('users')
            .doc(artistUID)
            .collection('songs')
            .doc(timeStamp)
            .update({
              'comments': comments+1,
            });
          });
  }




  unlikeRequest(String musicStyle, String timeStamp, int likes, int totalLikes, String artistUID) {
    FirebaseFirestore.instance
      .collection(musicStyle)
      .doc(timeStamp)
      .update({
        'likes': likes-1,
      }).whenComplete(() {
        print('Unlike in music collection');
        FirebaseFirestore.instance
          .collection('users')
          .doc(artistUID)
          .collection('songs')
          .doc(timeStamp)
          .update({
            'likes': likes-1,
          }).whenComplete(() {
            print('Unliked in artist collection song');
            if(this.mounted) {
              setState(() {
                widget.songsLikedMap.remove(timeStamp);
              });
            }
            print('new songsLikedMap : ${widget.songsLikedMap}');
            FirebaseFirestore.instance
              .collection('users')
              .doc(widget.currentUser)
              .update({
                'songsLiked': widget.songsLikedMap,
                }).whenComplete(() {
                  print('Unliked in current user songLiked');
                  FirebaseFirestore.instance
                    .collection('users')
                    .doc(artistUID)
                    .update({
                      'likes': totalLikes-1,
                    });
                });
           });
      });
  }





  likeRequest(String musicStyle, String timeStamp, int likes, int totalLikes, String artistUID) {
    FirebaseFirestore.instance
      .collection(musicStyle)
      .doc(timeStamp)
      .update({
        'likes': likes+1,
      }).whenComplete(() {
        print('like in music collection');
        FirebaseFirestore.instance
          .collection('users')
          .doc(artistUID)
          .collection('songs')
          .doc(timeStamp)
          .update({
            'likes': likes+1,
          }).whenComplete(() {
            if(this.mounted) {
              setState(() {
              widget.songsLikedMap[timeStamp] = timeStamp;
              });
            }
          print('liked in artist collection song');
          FirebaseFirestore.instance
            .collection('users')
            .doc(widget.currentUser)
            .update({
              'songsLiked': widget.songsLikedMap,
              }).whenComplete(() {
                print('liked in current user songLiked');
                FirebaseFirestore.instance
                  .collection('users')
                  .doc(artistUID)
                  .update({
                    'likes': totalLikes+1,
                  });
              });
          });
      });
  }

  viewRequest(String musicStyle, String timeStamp, int views, String artistUID) {
    FirebaseFirestore.instance
      .collection(musicStyle)
      .doc(timeStamp)
      .update({
        'views': views+1,
      }).whenComplete(() {
        FirebaseFirestore.instance
          .collection('users')
          .doc(artistUID)
          .collection('songs')
          .doc(timeStamp)
          .update({
            'views': views+1,
          }).whenComplete(() {
            print('Ok view +1 (stored)');
          });
      });
  }







}